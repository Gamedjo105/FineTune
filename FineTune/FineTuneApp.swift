// FineTune/FineTuneApp.swift
import SwiftUI
import UserNotifications
import FluidMenuBarExtra
import os

private let logger = Logger(subsystem: "com.finetuneapp.FineTune", category: "App")

@main
struct FineTuneApp: App {
    @State private var audioEngine: AudioEngine
    @State private var showMenuBarExtra = true

    var body: some Scene {
        FluidMenuBarExtra("FineTune", image: "MenuBarIcon", isInserted: $showMenuBarExtra) {
            MenuBarPopupView(
                audioEngine: audioEngine,
                deviceVolumeMonitor: audioEngine.deviceVolumeMonitor
            )
        }

        Settings { EmptyView() }
    }

    init() {
        let settings = SettingsManager()
        let engine = AudioEngine(settingsManager: settings)
        _audioEngine = State(initialValue: engine)

        // DeviceVolumeMonitor is now created and started inside AudioEngine
        // This ensures proper initialization order: deviceMonitor.start() -> deviceVolumeMonitor.start()

        // Request notification authorization (for device disconnect alerts)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, error in
            if let error {
                logger.error("Notification authorization error: \(error.localizedDescription)")
            }
            // If not granted, notifications will silently not appear - acceptable behavior
        }

        // Flush settings on app termination to prevent data loss from debounced saves
        NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [settings] _ in
            MainActor.assumeIsolated {
                settings.flushSync()
            }
        }
    }
}
