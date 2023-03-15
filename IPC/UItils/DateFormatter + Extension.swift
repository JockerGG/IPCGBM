//
//  DateFormatter + Extension.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

extension DateFormatter {
    enum Formats: String {
        case iso08601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case simple = "dd/MM/YY"
    }
    static func formatter(with dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
}
