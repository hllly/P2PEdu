// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private struct PrivateConstants {
    static let LogoTopOffset = -300.0
    static let LogoHeight = 200.0
}

class LoginLogoController: LoginBaseController {
    /**
     * Main view, which is used as container for all subviews.
     */
    var mainContainerView: UIView!
    var mainContainerViewTopConstraint: Constraint?

    var logoImageView: UIImageView!

    /**
     * Use this container to add subviews in subclasses.
     * Is placed under logo.
     */
    var contentContainerView: UIView!

    override func loadView() {
        super.loadView()

        createMainContainerView()
        createLogoImageView()
        createContainerView()

        installConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated:animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated:animated)
    }
}

private extension LoginLogoController {
    func createMainContainerView() {
        mainContainerView = UIView()
        //登陆页背景色
        //mainContainerView.backgroundColor = .clear
        mainContainerView.backgroundColor = UIColor.white   //add by hll
        view.addSubview(mainContainerView)
    }

    func createLogoImageView() {
        //登陆页面logo
        //let image = UIImage(named: "login-logo")
        let image = UIImage(named: "logo")  //add by hll

        logoImageView = UIImageView(image: image)
        logoImageView.contentMode = .scaleAspectFit
        mainContainerView.addSubview(logoImageView)
    }

    func createContainerView() {
        contentContainerView = UIView()
        contentContainerView.backgroundColor = .clear
        mainContainerView.addSubview(contentContainerView)
    }

    func installConstraints() {
        mainContainerView.snp.makeConstraints {
            mainContainerViewTopConstraint = $0.top.equalTo(view).constraint
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(view)
        }

        logoImageView.snp.makeConstraints {
            $0.centerX.equalTo(mainContainerView)
            $0.top.equalTo(mainContainerView.snp.centerY).offset(PrivateConstants.LogoTopOffset)
            $0.height.equalTo(PrivateConstants.LogoHeight)
        }

        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.VerticalOffset)
            $0.bottom.equalTo(mainContainerView)
            $0.leading.trailing.equalTo(mainContainerView)
        }
    }
}
