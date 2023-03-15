//
//  FileManager.swift
//  IPCTests
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

enum FileManager {
    static func getFileData(with name: String, type: String) -> Data? {
        guard let path = Bundle(for: LARepositorySpy.self).path(forResource: name, ofType: type) else { return nil }
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
}
