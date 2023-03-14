//
//  String + Extension.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
