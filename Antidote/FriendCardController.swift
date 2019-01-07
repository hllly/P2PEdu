// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol FriendCardControllerDelegate: class {
    func friendCardControllerChangeNickname(_ controller: FriendCardController, forFriend friend: OCTFriend)
    func friendCardControllerOpenChat(_ controller: FriendCardController, forFriend friend: OCTFriend)
    func friendCardControllerCall(_ controller: FriendCardController, toFriend friend: OCTFriend)
    func friendCardControllerVideoCall(_ controller: FriendCardController, toFriend friend: OCTFriend)
}

class FriendCardController: StaticTableController {
    weak var delegate: FriendCardControllerDelegate?

    fileprivate weak var submanagerObjects: OCTSubmanagerObjects!

    fileprivate let friend: OCTFriend

    fileprivate let avatarManager: AvatarManager
    fileprivate var friendToken: RLMNotificationToken?

    fileprivate let avatarModel: StaticTableAvatarCellModel
    fileprivate let chatButtonsModel: StaticTableChatButtonsCellModel
    fileprivate let nicknameModel: StaticTableDefaultCellModel
    fileprivate let nameModel: StaticTableDefaultCellModel
    fileprivate let statusMessageModel: StaticTableDefaultCellModel
    fileprivate let publicKeyModel: StaticTableDefaultCellModel

    init(theme: Theme, friend: OCTFriend, submanagerObjects: OCTSubmanagerObjects) {
        self.submanagerObjects = submanagerObjects
        self.friend = friend

        self.avatarManager = AvatarManager(theme: theme)

        avatarModel = StaticTableAvatarCellModel()
        chatButtonsModel = StaticTableChatButtonsCellModel()
        nicknameModel = StaticTableDefaultCellModel()
        nameModel = StaticTableDefaultCellModel()
        statusMessageModel = StaticTableDefaultCellModel()
        publicKeyModel = StaticTableDefaultCellModel()

        super.init(theme: theme, style: .plain, model: [
            [
                avatarModel,
                chatButtonsModel,
            ],
            [
                nicknameModel,
                nameModel,
                statusMessageModel,
            ],
            [
                publicKeyModel,
            ],
        ])

        updateModels()
    }

    deinit {
        friendToken?.invalidate()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let predicate = NSPredicate(format: "uniqueIdentifier == %@", friend.uniqueIdentifier)
        let results = submanagerObjects.friends(predicate: predicate)
        friendToken = results.addNotificationBlock { [unowned self] change in
            switch change {
                case .initial:
                    break
                case .update:
                    self.updateModels()
                    self.reloadTableView()
                case .error(let error):
                    fatalError("\(error)")
            }
        }
    }
}

private extension FriendCardController {
    func updateModels() {
        title = friend.nickname

        if let data = friend.avatarData {
            avatarModel.avatar = UIImage(data: data)
        }
        else {
            avatarModel.avatar = avatarManager.avatarFromString(
                    friend.nickname,
                    diameter: StaticTableAvatarCellModel.Constants.AvatarImageSize)
        }
        avatarModel.userInteractionEnabled = false

        chatButtonsModel.chatButtonHandler = { [unowned self] in
            self.delegate?.friendCardControllerOpenChat(self, forFriend: self.friend)
        }
        chatButtonsModel.callButtonHandler = { [unowned self] in
            self.delegate?.friendCardControllerCall(self, toFriend: self.friend)
        }
        chatButtonsModel.videoButtonHandler = { [unowned self] in
            self.delegate?.friendCardControllerVideoCall(self, toFriend: self.friend)
        }
        chatButtonsModel.chatButtonEnabled = true
        chatButtonsModel.callButtonEnabled = friend.isConnected
        chatButtonsModel.videoButtonEnabled = friend.isConnected

        nicknameModel.title = String(localized: "nickname")
        nicknameModel.value = friend.nickname
        nicknameModel.rightImageType = .arrow
        nicknameModel.didSelectHandler = { [unowned self] _ -> Void in
            self.delegate?.friendCardControllerChangeNickname(self, forFriend: self.friend)
        }

        nameModel.title = String(localized: "name")
        nameModel.value = friend.name
        nameModel.userInteractionEnabled = false

        statusMessageModel.title = String(localized: "status_message")
        statusMessageModel.value = friend.statusMessage
        statusMessageModel.userInteractionEnabled = false

        publicKeyModel.title = String(localized: "public_key")
        publicKeyModel.value = friend.publicKey
        publicKeyModel.userInteractionEnabled = false
    }
}
