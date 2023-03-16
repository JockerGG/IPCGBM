//
//  NetworkRequest.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkRequest {
    associatedtype Response
    
    /// The url for the request.
    var url: String { get }
    
    /// The method of the request.
    var method: HTTPMethod { get }
    
    /// The headers of the request.
    var headers: [String: String] { get }
    
    /// The query items of the request.
    var queryItems: [String: String] { get }
    
    /// Decode the response data to the codable model. 
    func decode(_ data: Data) throws -> Response
}

extension NetworkRequest {
    var headers: [String: String] {
        [:]
    }
    
    var queryItems: [String: String] {
        [:]
    }
}

extension NetworkRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(
            DateFormatter.formatter(with: DateFormatter.Formats.iso08601.rawValue)
        )
        
        return try decoder.decode(Response.self, from: data)
    }
}
