//
//  IPCRepository.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

protocol IPCRepositorable {
    func getIPCData(completion: @escaping ((Result<[IPCData], Error>) -> Void))
}

final class IPCRepository: IPCRepositorable {
    /// Network service to perform requests.
    private let service: NetworkService
    
    /// Request to be executed.
    private let request: IPCRequest
    
    /// - Parameters:
    ///     - service: The `NetworkService` implementation.
    ///     - request: The `NetworkRequest` implementation.
    init(service: NetworkService = NetworkServiceImplementation(session: URLSession.shared), request: IPCRequest) {
        self.service = service
        self.request = request
    }
    
    /// Retrieves the IPC data from the server. 
    func getIPCData(completion: @escaping ((Result<[IPCData], Error>) -> Void)) {
        service.request(request, completion: completion)
    }
}
