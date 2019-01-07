// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UIApplication {
    class var isActive: Bool {
        get {
            switch shared.applicationState {
                case .active:
                    return true
                case .inactive:
                    return false
                case .background:
                    return false
            }
        }
    }
}
