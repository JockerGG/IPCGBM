//
//  IPCRepository.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

protocol IPCRepositorable {
    func getIPCData(completion: @escaping ((Result<[ChartModel], Error>) -> Void))
}

final class IPCRepository: IPCRepositorable {
    private let service: NetworkService
    private let request: IPCRequest
    
    init(service: NetworkService = NetworkServiceImplementation(session: URLSession.shared), request: IPCRequest) {
        self.service = service
        self.request = request
    }
    
    func getIPCData(completion: @escaping ((Result<[ChartModel], Error>) -> Void)) {
        service.request(request, completion: completion)
    }
}
