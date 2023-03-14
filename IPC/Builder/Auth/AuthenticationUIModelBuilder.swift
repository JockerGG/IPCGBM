//
//  AuthenticationUIModelBuilder.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import LocalAuthentication

struct AuthenticationUIModelBuilder {
    func assemble(with biometricType: LABiometryType) -> AuthenticationView.UIModel {
        .init(biometricType: biometricType)
    }
}
