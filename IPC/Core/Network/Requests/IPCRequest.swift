//
//  IPCRequest.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

struct IPCRequest: NetworkRequest {
    typealias Response = [IPCData]
    
    var url: String {
        "https://run.mocky.io/v3/cc4c350b-1f11-42a0-a1aa-f8593eafeb1e"
    }
    
    var method: HTTPMethod {
        .get
    }
}
