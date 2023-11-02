//
//  NetworkMonitor.swift
//  PokeAPI
//
//  Created by Shady Elkassas on 01/11/2023.
//

import Foundation
import Network

//Class for network status
class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    
    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
