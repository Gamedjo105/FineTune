// FineTune/Models/VolumeState.swift
import Foundation

@Observable
final class VolumeState {
    private var volumes: [pid_t: Float] = [:]

    func getVolume(for pid: pid_t) -> Float {
        volumes[pid] ?? 1.0
    }

    func setVolume(for pid: pid_t, to volume: Float) {
        volumes[pid] = volume
    }

    func removeVolume(for pid: pid_t) {
        volumes.removeValue(forKey: pid)
    }

    func cleanup(keeping pids: Set<pid_t>) {
        volumes = volumes.filter { pids.contains($0.key) }
    }
}
