//
//  NetworkStateMonitor.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation
import Network
import Combine

//protocol NetworkMonitorProtocol {
//    var isConnectedPublisher: AnyPublisher<Bool, Never> { get set }
//}

//final class NetworkMonitor: NetworkMonitorProtocol {

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "NetworkMonitorQueue")
    let subject = CurrentValueSubject<Bool, Never>(false)
    
    /// Publisher for network connectivity
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private init() {
        self.monitor = NWPathMonitor()
        startMonitoring()
    }
    
    /// Start monitoring network changes
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self.subject.send(isConnected)
            }
        }

        // Emit the initial connectivity status
        DispatchQueue.global().async {
            let isConnected = self.monitor.currentPath.status == .satisfied
            DispatchQueue.main.async {
                self.subject.send(isConnected)
            }
        }

        monitor.start(queue: monitorQueue)
    }
    
    /// Stop monitoring
    deinit {
        monitor.cancel()
    }
}
