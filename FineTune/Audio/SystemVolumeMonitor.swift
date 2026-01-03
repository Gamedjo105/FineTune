// FineTune/Audio/SystemVolumeMonitor.swift
import AppKit
import AudioToolbox
import os

@Observable
@MainActor
final class SystemVolumeMonitor {
    private(set) var volume: Float = 1.0
    private(set) var deviceName: String = "Unknown"
    private(set) var deviceIcon: NSImage?

    private let deviceMonitor: AudioDeviceMonitor
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "FineTune", category: "SystemVolumeMonitor")

    private var volumeListenerBlock: AudioObjectPropertyListenerBlock?
    private var defaultDeviceListenerBlock: AudioObjectPropertyListenerBlock?

    private var currentDeviceID: AudioDeviceID = .unknown
    private var volumeListenerDeviceID: AudioDeviceID = .unknown

    private var defaultDeviceAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )

    private var volumeAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
        mScope: kAudioDevicePropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMain
    )

    init(deviceMonitor: AudioDeviceMonitor) {
        self.deviceMonitor = deviceMonitor
    }

    func start() {
        guard defaultDeviceListenerBlock == nil else { return }

        logger.debug("Starting system volume monitor")

        // Read initial state
        refreshDefaultDevice()

        // Listen for default output device changes
        defaultDeviceListenerBlock = { [weak self] _, _ in
            Task { @MainActor [weak self] in
                self?.handleDefaultDeviceChanged()
            }
        }

        let defaultDeviceStatus = AudioObjectAddPropertyListenerBlock(
            .system,
            &defaultDeviceAddress,
            .main,
            defaultDeviceListenerBlock!
        )

        if defaultDeviceStatus != noErr {
            logger.error("Failed to add default device listener: \(defaultDeviceStatus)")
        }

        // Start listening for volume changes on current device
        addVolumeListener()
    }

    func stop() {
        logger.debug("Stopping system volume monitor")

        // Remove default device listener
        if let block = defaultDeviceListenerBlock {
            AudioObjectRemovePropertyListenerBlock(.system, &defaultDeviceAddress, .main, block)
            defaultDeviceListenerBlock = nil
        }

        // Remove volume listener
        removeVolumeListener()
    }

    func setVolume(_ volume: Float) {
        guard currentDeviceID.isValid else {
            logger.warning("Cannot set volume: no valid device")
            return
        }

        let success = currentDeviceID.setOutputVolumeScalar(volume)
        if success {
            self.volume = volume
        } else {
            logger.warning("Failed to set volume on device \(self.currentDeviceID)")
        }
    }

    // MARK: - Private Methods

    private func refreshDefaultDevice() {
        do {
            let newDeviceID: AudioDeviceID = try AudioObjectID.system.read(
                kAudioHardwarePropertyDefaultOutputDevice,
                defaultValue: AudioDeviceID.unknown
            )

            guard newDeviceID.isValid else {
                logger.warning("Default output device is invalid")
                deviceName = "Unknown"
                deviceIcon = nil
                volume = 1.0
                return
            }

            // Only update listeners if device actually changed
            if newDeviceID != currentDeviceID {
                removeVolumeListener()
                currentDeviceID = newDeviceID
                addVolumeListener()
            }

            // Update device info from deviceMonitor
            updateDeviceInfo()

            // Read current volume
            volume = currentDeviceID.readOutputVolumeScalar()

            logger.debug("Default device: \(self.deviceName), volume: \(self.volume)")

        } catch {
            logger.error("Failed to read default output device: \(error.localizedDescription)")
        }
    }

    private func updateDeviceInfo() {
        // Find device info from deviceMonitor by matching device ID
        if let device = deviceMonitor.outputDevices.first(where: { $0.id == currentDeviceID }) {
            deviceName = device.name
            deviceIcon = device.icon
        } else {
            // Fallback: read name directly from device if not in monitor's list
            deviceName = (try? currentDeviceID.readDeviceName()) ?? "Unknown"
            deviceIcon = currentDeviceID.readDeviceIcon()
                ?? NSImage(systemSymbolName: currentDeviceID.suggestedIconSymbol(), accessibilityDescription: deviceName)
        }
    }

    private func handleDefaultDeviceChanged() {
        logger.debug("Default output device changed")
        refreshDefaultDevice()
    }

    private func handleVolumeChanged(for deviceID: AudioDeviceID) {
        // Only process if this callback is for the current device
        guard deviceID == currentDeviceID, currentDeviceID.isValid else { return }
        volume = currentDeviceID.readOutputVolumeScalar()
        logger.debug("Volume changed: \(self.volume)")
    }

    private func addVolumeListener() {
        guard currentDeviceID.isValid else { return }
        volumeListenerDeviceID = currentDeviceID
        let deviceID = currentDeviceID  // capture for closure

        volumeListenerBlock = { [weak self] _, _ in
            Task { @MainActor [weak self] in
                self?.handleVolumeChanged(for: deviceID)
            }
        }

        let status = AudioObjectAddPropertyListenerBlock(
            volumeListenerDeviceID,
            &volumeAddress,
            .main,
            volumeListenerBlock!
        )

        if status != noErr {
            logger.warning("Failed to add volume listener: \(status)")
        }
    }

    private func removeVolumeListener() {
        guard let block = volumeListenerBlock, volumeListenerDeviceID.isValid else {
            volumeListenerBlock = nil
            volumeListenerDeviceID = .unknown
            return
        }

        AudioObjectRemovePropertyListenerBlock(volumeListenerDeviceID, &volumeAddress, .main, block)
        volumeListenerBlock = nil
        volumeListenerDeviceID = .unknown
    }

    deinit {
        // Note: Can't call stop() here due to MainActor isolation
        // Listeners will be cleaned up when the process exits
    }
}
