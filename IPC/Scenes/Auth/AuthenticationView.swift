//
//  AuthenticationView.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import Foundation
import LocalAuthentication
import UIKit

final class AuthenticationView: BaseView<AuthenticationView.UIModel, AuthenticationView.Actions> {
    struct UIModel {
        let biometricType: LABiometryType
    }
    
    /// Notify to the view controller that the user has interacted with the view.
    enum Actions {
        /// Notify the view controller that the user has tapped the login button.
        case didTapLoginButton
    }
    
    private lazy var biometricImage: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForAutolayout()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1, compatibleWith: nil)
        label.prepareForAutolayout()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .systemGray
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)
        label.prepareForAutolayout()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .systemGray
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.prepareForAutolayout()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = .buttonHeight / 2
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    override func addSubviews() {
        self.backgroundColor = .white
        addSubview(biometricImage)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(loginButton)
    }
    
    override func setConstraints() {
        let biometricImageConstraints = [
            biometricImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            biometricImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            biometricImage.heightAnchor.constraint(equalToConstant: .biometricHeight),
            biometricImage.widthAnchor.constraint(equalToConstant: .biometricHeight)
        ]
        
        let messageLabelConstraints = [
            biometricImage.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            messageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 24)
        ]
        
        let titleLabelConstraints = [
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 24)
        ]
        
        let loginButtonConstraints = [
            loginButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            loginButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 24),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24)
        ]
        
        NSLayoutConstraint.activate(
            biometricImageConstraints +
            messageLabelConstraints +
            titleLabelConstraints +
            loginButtonConstraints
        )
    }
    
    override func updateUI() {
        guard let uiModel = uiModel else { return }
        let biometricName: String = uiModel.biometricType == .faceID ? .faceId : .touchId
        self.biometricImage.image = uiModel.biometricType == .touchID ? .touchId : .faceId
        self.titleLabel.text = .title
        self.messageLabel.text = String(format: .subtitle, biometricName)
        self.loginButton.setTitle(String(format: .buttonTitle, biometricName), for: .normal)
    }
    
    @objc func didTapLoginButton() {
        actionHandler?(.didTapLoginButton)
    }
}

private extension String {
    static var title: String { "authentication-login-title".localized }
    static var subtitle: String { "authentication-login-subtitle".localized }
    static var buttonTitle: String { "authentication-login-button-title".localized }
    static var faceId: String { "authentication-login-face-id".localized }
    static var touchId: String { "authentication-login-touch-id".localized }
}

private extension CGFloat {
    static let buttonHeight: CGFloat = 54.0
    static let biometricHeight: CGFloat = 60.0
}
