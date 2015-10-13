//
//  LoginChoiceController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit
import SnapKit

private struct Constants {
    static let HorizontalOffset = 40.0
    static let VerticalOffset = 40.0
    static let OrVerticalOffset = 8.0
}

protocol LoginChoiceControllerDelegate {
    func loginChoiceControllerCreateAccount(controller: LoginChoiceController)
    func loginChoiceControllerImportProfile(controller: LoginChoiceController)
}

class LoginChoiceController: LoginLogoController {
    var delegate: LoginChoiceControllerDelegate?

    var welcomeLabel: UILabel!
    var createAccountButton: UIButton!
    var orLabel: UILabel!
    var importProfileButton: UIButton!

    override func loadView() {
        super.loadView()

        createLabels()
        createButtons()

        installConstraints()
    }
}

// MARK: Actions
private extension LoginChoiceController {
    func createAccountButtonPressed() {
        delegate?.loginChoiceControllerCreateAccount(self)
    }

    func importProfileButtonPressed() {
        delegate?.loginChoiceControllerImportProfile(self)
    }
}

private extension LoginChoiceController {
    func createLabels() {
        welcomeLabel = createLabelWithText(String(localized:"login_welcome_text"))
        orLabel = createLabelWithText(String(localized:"or_text"))
    }

    func createButtons() {
        createAccountButton = createButtonWithTitle(String(localized:"create_account"), action: "createAccountButtonPressed")
        importProfileButton = createButtonWithTitle(String(localized:"import_profile"), action: "importProfileButtonPressed")
    }

    func installConstraints() {
        welcomeLabel.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(containerView)
            make.left.equalTo(containerView).offset(Constants.HorizontalOffset)
            make.right.equalTo(containerView).offset(-Constants.HorizontalOffset)
        }

        createAccountButton.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(welcomeLabel.snp_bottom).offset(Constants.VerticalOffset)
            make.left.right.equalTo(welcomeLabel)
        }

        orLabel.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(createAccountButton.snp_bottom).offset(Constants.OrVerticalOffset)
            make.left.right.equalTo(welcomeLabel)
        }

        importProfileButton.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(orLabel.snp_bottom).offset(Constants.OrVerticalOffset)
            make.left.right.equalTo(welcomeLabel)
        }
    }

    func createLabelWithText(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = theme.colorForType(.LoginDescriptionLabel)
        label.textAlignment = .Center
        label.backgroundColor = .clearColor()

        containerView.addSubview(label)

        return label
    }

    func createButtonWithTitle(title: String, action: Selector) -> UIButton {
        let button = LoginButton(theme: theme)
        button.setTitle(title, forState:.Normal)
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)

        containerView.addSubview(button)

        return button
    }
}
