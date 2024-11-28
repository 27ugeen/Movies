//
//  NetworkMonitor.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import Foundation
import Network
import SystemConfiguration

/// Protocol defining the interface for network monitoring.
protocol NetworkMonitorProtocol: AnyObject {
    /// Indicates the current network connection status.
    var isConnected: Bool { get }
    /// A delegate to notify about changes in network status.
    var delegate: NetworkMonitorDelegate? { get set }
}

/// Protocol for handling network status change notifications.
protocol NetworkMonitorDelegate: AnyObject {
    /// Called when the network status changes.
    /// - Parameter isConnected: A boolean indicating the new network connection status.
    func networkStatusDidChange(isConnected: Bool)
}

/// Class for monitoring network connectivity using NWPathMonitor and SCNetworkReachability.
final class NetworkMonitor: NetworkMonitorProtocol {
    /// Shared singleton instance for centralized monitoring.
    static let shared = NetworkMonitor()

    /// NWPathMonitor instance for real-time network monitoring.
    private let monitor = NWPathMonitor()
    /// Background queue for running the NWPathMonitor.
    private let queue = DispatchQueue.global(qos: .background)
    /// SCNetworkReachability instance for initial connectivity check.
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")

    /// Current network connection status.
    private(set) var isConnected: Bool = true {
        didSet {
            // Notify the delegate only if the connection status changes.
            if isConnected != oldValue {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.networkStatusDidChange(isConnected: self?.isConnected ?? false)
                }
            }
        }
    }

    /// Delegate to handle network status changes.
    weak var delegate: NetworkMonitorDelegate?

    /// Private initializer to prevent external instantiation.
    private init() {
        // Initial connectivity check using SCNetworkReachability.
        isConnected = checkInitialInternetConnectivity()

        // Setting up the NWPathMonitor to track real-time connectivity changes.
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    /// Checks the initial network connectivity using SCNetworkReachability.
    /// - Returns: `true` if the network is reachable, `false` otherwise.
    private func checkInitialInternetConnectivity() -> Bool {
        guard let reachability = reachability else { return false }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return isReachable && !needsConnection
    }
}
