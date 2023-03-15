//
//  AuthenticationViewModel.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import UIKit
import LocalAuthentication

final class AuthenticationViewModel: BaseViewModel<AuthenticationViewModel.NotifierActions> {
    enum NotifierActions {
        case update(biometricType: LABiometryType)
        case didLoginSuccess
        case didShowAlert(title: String, message: String, actions: [AlertAction])
    }
    
    private let localAuthenticationValidatorRepository: LAPermissionsValidatorRepositorable
    private let localAuthenticationRepository: LARepositorable
    private let localContext: LAContext
    
    init(localAuthenticationValidatorRepository: LAPermissionsValidatorRepositorable,
         localAuthenticationRepository: LARepositorable,
         localContext: LAContext) {
        self.localAuthenticationRepository = localAuthenticationRepository
        self.localAuthenticationValidatorRepository = localAuthenticationValidatorRepository
        self.localContext = localContext
        super.init()
        notifier?(.update(biometricType: localContext.biometryType))
    }
    
    func didTapLogin() {
        let validationResult = localAuthenticationValidatorRepository.validate()
        
        switch validationResult {
        case .granted:
            localAuthenticationRepository.login { [weak self] result in
                switch result {
                case .success:
                    self?.notifier?(.didLoginSuccess)
                case .failure(let error):
                    self?.notifier?(.didShowAlert(title: "authentication-login-error-title".localized,
                                                  message: error.localizedDescription,
                                                  actions: [
                                                    AlertAction(title: "authentication-login-error-retry".localized,
                                                                style: .default,
                                                                action: {
                                                                    self?.didTapLogin()
                                                                })
                                                  ]))
                }
                
            }
        case .configuration(let error):
            self.notifier?(.didShowAlert(title: "authentication-login-error-title".localized,
                                         message: Unwrapper.unwrap(error?.localizedDescription),
                                         actions: [
                                            AlertAction(title: "authentication-login-error-configuration".localized,
                                                        style: .default,
                                                        action: { [weak self] in
                                                            self?.didTapLogin()
                                                        })
                                         ]))
        }
    }
}
