//
//  CGFloat + Extension.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

extension CGFloat {
    func currencyFormat() -> String {
        String(format: "$%.02f", self)
    }
}
