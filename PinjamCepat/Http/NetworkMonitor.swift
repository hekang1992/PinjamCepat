//
//  NetworkMonitor.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation
import Alamofire

final class NetworkMonitor {

    static let shared = NetworkMonitor()

    typealias StatusHandler = (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void

    var statusChanged: StatusHandler?
    
    private var isListening = false

    private let reachabilityManager: NetworkReachabilityManager?

    private init() {
        self.reachabilityManager = NetworkReachabilityManager()
    }

    func startListening() {
        guard !isListening else { return }
        isListening = true
        
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            self?.handleStatusChange(status)
        })
    }

    func stopListening() {
        guard isListening else { return }
        isListening = false

        reachabilityManager?.stopListening()
    }

    private func handleStatusChange(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        statusChanged?(status)
    }
}
