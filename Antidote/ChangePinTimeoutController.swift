// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol ChangePinTimeoutControllerDelegate: class {
    func changePinTimeoutControllerDone(_ controller: ChangePinTimeoutController)
}

class ChangePinTimeoutController: StaticTableController {
    weak var delegate: ChangePinTimeoutControllerDelegate?

    fileprivate weak var submanagerObjects: OCTSubmanagerObjects!

    fileprivate let immediatelyModel = StaticTableDefaultCellModel()
    fileprivate let seconds30Model = StaticTableDefaultCellModel()
    fileprivate let minute1Model = StaticTableDefaultCellModel()
    fileprivate let minute2Model = StaticTableDefaultCellModel()
    fileprivate let minute5Model = StaticTableDefaultCellModel()

    init(theme: Theme, submanagerObjects: OCTSubmanagerObjects) {
        self.submanagerObjects = submanagerObjects

        super.init(theme: theme, style: .plain, model: [
            [
                immediatelyModel,
                seconds30Model,
                minute1Model,
                minute2Model,
                minute5Model,
            ],
        ])

        updateModels()

        title = String(localized: "pin_lock_timeout")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChangePinTimeoutController {
    func updateModels() {
        let settings = submanagerObjects.getProfileSettings()

        immediatelyModel.value = String(localized: "pin_lock_immediately")
        immediatelyModel.didSelectHandler = immediatelyHandler
        immediatelyModel.rightImageType = .none

        seconds30Model.value = String(localized: "pin_lock_30_seconds")
        seconds30Model.didSelectHandler = seconds30Handler
        seconds30Model.rightImageType = .none

        minute1Model.value = String(localized: "pin_lock_1_minute")
        minute1Model.didSelectHandler = minute1Handler
        minute1Model.rightImageType = .none

        minute2Model.value = String(localized: "pin_lock_2_minutes")
        minute2Model.didSelectHandler = minute2Handler
        minute2Model.rightImageType = .none

        minute5Model.value = String(localized: "pin_lock_5_minutes")
        minute5Model.didSelectHandler = minute5Handler
        minute5Model.rightImageType = .none


        switch settings.lockTimeout {
            case .Immediately:
                immediatelyModel.rightImageType = .checkmark
            case .Seconds30:
                seconds30Model.rightImageType = .checkmark
            case .Minute1:
                minute1Model.rightImageType = .checkmark
            case .Minute2:
                minute2Model.rightImageType = .checkmark
            case .Minute5:
                minute5Model.rightImageType = .checkmark
        }
    }

    func immediatelyHandler(_: StaticTableBaseCell) {
        selectedTimeout(.Immediately)
    }

    func seconds30Handler(_: StaticTableBaseCell) {
        selectedTimeout(.Seconds30)
    }

    func minute1Handler(_: StaticTableBaseCell) {
        selectedTimeout(.Minute1)
    }

    func minute2Handler(_: StaticTableBaseCell) {
        selectedTimeout(.Minute2)
    }

    func minute5Handler(_: StaticTableBaseCell) {
        selectedTimeout(.Minute5)
    }

    func selectedTimeout(_ timeout: ProfileSettings.LockTimeout) {
        let settings = submanagerObjects.getProfileSettings()
        settings.lockTimeout = timeout
        submanagerObjects.saveProfileSettings(settings)

        delegate?.changePinTimeoutControllerDone(self)
    }
}
