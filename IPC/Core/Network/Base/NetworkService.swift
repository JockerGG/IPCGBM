//
//  NetworkService.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol URLSessionProtocol {
    func performTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol NetworkService {
    func request<Request: NetworkRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class NetworkServiceImplementation: NetworkService {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func request<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request : NetworkRequest {
        guard var urlComponent = URLComponents(string: request.url),
              let url = urlComponent.url else {
            return completion(.failure(IPCError.error(reason: "network-service-error".localized)))
        }
        
        urlComponent.queryItems = request.queryItems.map { .init(name: $0.key, value: $0.value) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        session.performTask(with: urlRequest) { data, response, error in
            if let _ = error {
                return completion(.failure(IPCError.error(reason: "network-service-error-response".localized)))
            }
            
            guard let response = response as? HTTPURLResponse,
                  200..<300 ~= response.statusCode,
                  let data = data else {
                return completion(.failure(IPCError.error(reason: "network-service-error-response".localized)))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }

}

extension URLSession: URLSessionProtocol {
    func performTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return self.dataTask(with: request, completionHandler: completionHandler)
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }
