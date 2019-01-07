// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class ChatBaseTextCell: ChatMovableDateCell {
    struct Constants {
        static let BubbleVerticalOffset = 7.0
        static let BubbleHorizontalOffset = 20.0
    }

    var bubbleNormalBackground: UIColor?
    var bubbleView: BubbleView!
    
    override func setupWithTheme(_ theme: Theme, model: BaseCellModel) {
        super.setupWithTheme(theme, model: model)

        guard let textModel = model as? ChatBaseTextCellModel else {
            assert(false, "Wrong model \(model) passed to cell \(self)")
            return
        }

        canBeCopied = true
        bubbleView.text = textModel.message
        bubbleView.textColor = theme.colorForType(.NormalText)
    }

    override func createViews() {
        super.createViews()

        bubbleView = BubbleView()
        contentView.addSubview(bubbleView)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        bubbleView.isUserInteractionEnabled = !editing
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        bubbleView.backgroundColor = bubbleNormalBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isEditing {
            bubbleView.backgroundColor = bubbleNormalBackground
            return
        }

        if selected {
            bubbleView.backgroundColor = bubbleNormalBackground?.darkerColor()
        }
        else {
            bubbleView.backgroundColor = bubbleNormalBackground
        }
    }
}

// Accessibility
extension ChatBaseTextCell {
    override var accessibilityValue: String? {
        get {
            var value = bubbleView.text!
            if let sValue = super.accessibilityValue {
                value += ", " + sValue
            }

            return value
        }
        set {}
    }
}

// ChatEditable
extension ChatBaseTextCell {
    override func shouldShowMenu() -> Bool {
        return true
    }

    override func menuTargetRect() -> CGRect {
        return bubbleView.frame
    }

    override func willShowMenu() {
        super.willShowMenu()

        bubbleView.selectable = false
    }

    override func willHideMenu() {
        super.willHideMenu()

        bubbleView.selectable = true
    }
}
