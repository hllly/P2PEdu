// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol ChatsTabCoordinatorDelegate: class {
    func chatsTabCoordinator(_ coordinator: ChatsTabCoordinator, chatWillAppear chat: OCTChat)
    func chatsTabCoordinator(_ coordinator: ChatsTabCoordinator, chatWillDisapper chat: OCTChat)
    func chatsTabCoordinator(_ coordinator: ChatsTabCoordinator, callToChat chat: OCTChat, enableVideo: Bool)
}

class ChatsTabCoordinator: ActiveSessionNavigationCoordinator {
    weak var delegate: ChatsTabCoordinatorDelegate?

    fileprivate weak var submanagerObjects: OCTSubmanagerObjects!
    fileprivate weak var submanagerChats: OCTSubmanagerChats!
    fileprivate weak var submanagerFiles: OCTSubmanagerFiles!
    fileprivate weak var activeSessionCoordinatorDelegate: ChatPrivateControllerDelegate!

    init(theme: Theme, submanagerObjects: OCTSubmanagerObjects, submanagerChats: OCTSubmanagerChats, submanagerFiles: OCTSubmanagerFiles, activeSessionCoordinatorDelegate: ChatPrivateControllerDelegate!) {
        self.submanagerObjects = submanagerObjects
        self.submanagerChats = submanagerChats
        self.submanagerFiles = submanagerFiles
        self.activeSessionCoordinatorDelegate = activeSessionCoordinatorDelegate
        super.init(theme: theme)
    }

    override func startWithOptions(_ options: CoordinatorOptions?) {
        let controller = ChatListController(theme: theme, submanagerChats: submanagerChats, submanagerObjects: submanagerObjects, submanagerFiles: submanagerFiles, activeSessionCoordinatorDelegate: activeSessionCoordinatorDelegate)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: false)
    }

    func showChat(_ chat: OCTChat, animated: Bool) {
        if let top = navigationController.topViewController as? ChatPrivateController {
            if top.chat == chat {
                // controller is already visible
                return
            }
        }
        let controller = ChatPrivateController(
                theme: theme,
                chat: chat,
                submanagerChats: submanagerChats,
                submanagerObjects: submanagerObjects,
                submanagerFiles: submanagerFiles,
                delegate: self)
        navigationController.popToRootViewController(animated: false)
        navigationController.pushViewController(controller, animated: animated)
    }

    /**
        Returns active chat controller if it is visible, nil otherwise.
     */
    func activeChatController() -> ChatPrivateController? {
        return navigationController.topViewController as? ChatPrivateController
    }
}

extension ChatsTabCoordinator: ChatListControllerDelegate {
    func chatListController(_ controller: ChatListController, didSelectChat chat: OCTChat) {
        showChat(chat, animated: true)
    }
}

extension ChatsTabCoordinator: ChatPrivateControllerDelegate {
    func chatPrivateControllerWillAppear(_ controller: ChatPrivateController) {
        delegate?.chatsTabCoordinator(self, chatWillAppear: controller.chat)
        print("===================1")
    }

    func chatPrivateControllerWillDisappear(_ controller: ChatPrivateController) {
        delegate?.chatsTabCoordinator(self, chatWillDisapper: controller.chat)
        print("===================2")
    }

    func chatPrivateControllerCallToChat(_ controller: ChatPrivateController, enableVideo: Bool) {
        delegate?.chatsTabCoordinator(self, callToChat: controller.chat, enableVideo: enableVideo)
        print("===================3")
    }

    func chatPrivateControllerShowQuickLookController(
            _ controller: ChatPrivateController,
            dataSource: QuickLookPreviewControllerDataSource,
            selectedIndex: Int)
    {
        print("===================4")
        let controller = QuickLookPreviewController()
        controller.dataSource = dataSource
        controller.dataSourceStorage = dataSource
        controller.currentPreviewItemIndex = selectedIndex
        navigationController.present(controller, animated: true, completion: nil)
    }
}
