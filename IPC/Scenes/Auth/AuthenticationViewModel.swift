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
    /// Actions to nofity to the view controller a change.
    enum NotifierActions {
        /// Notify the view controller the correct biometry type that needs to be shown to the user.
        case update(biometricType: LABiometryType)
        
        /// Notify the view controller the user has authenticated correctly.
        case didLoginSuccess
        
        /// Notify the view controller that needs to present an alert to the user.
        case didShowAlert(title: String, message: String, actions: [AlertAction])
    }
    
    private let localAuthenticationValidatorRepository: LAPermissionsValidatorRepositorable
    private let localAuthenticationRepository: LARepositorable
    private let localContext: LAContext
    
    /// - Parameters:
    ///     - localAuthenticationValidatorRepository: The repository implementatation to validate if the user has granted permissions for local authentication.
    ///     - localAuthenticationRepository: The repository implementation to validae if the user is able to perform local authentication.
    ///     - localContext: `LAContext` to retrieve the correct biometry type.
    init(localAuthenticationValidatorRepository: LAPermissionsValidatorRepositorable,
         localAuthenticationRepository: LARepositorable,
         localContext: LAContext) {
        self.localAuthenticationRepository = localAuthenticationRepository
        self.localAuthenticationValidatorRepository = localAuthenticationValidatorRepository
        self.localContext = localContext
        super.init()
    }
    
    /// Validate if the user has granted permissions
    /// to retrieve the `biometryType`.
    /// If we don't validate the permissions, the biometry always be `.none`
    func validateBiometric() {
        _ = localAuthenticationValidatorRepository.validate()
        notifier?(.update(biometricType: localContext.biometryType))
    }
    
    /// Evaluate if the user is able to perform the local authentication
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
