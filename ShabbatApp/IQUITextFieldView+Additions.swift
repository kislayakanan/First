

import Foundation
import UIKit

/**
Uses default keyboard distance for textField.
*/
public let kIQUseDefaultKeyboardDistance = CGFloat.max

private var kIQKeyboardDistanceFromTextField = "kIQKeyboardDistanceFromTextField"

/**
UIView category for managing UITextField/UITextView
*/
public extension UIView {

    /**
    To set customized distance from keyboard for textField/textView. Can't be less than zero
    */
    public var keyboardDistanceFromTextField: CGFloat {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQKeyboardDistanceFromTextField) as? CGFloat {
                return aValue
            } else {
                return kIQUseDefaultKeyboardDistance
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQKeyboardDistanceFromTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

