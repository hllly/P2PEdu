// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class MockedChatProgressProtocol: ChatProgressProtocol {
    var updateProgress: ((_ progress: Float) -> Void)?
    var updateEta: ((_ eta: CFTimeInterval, _ bytesPerSecond: OCTToxFileSize) -> Void)?
}
