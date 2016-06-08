

import Foundation
import UIKit


private var kIQLayoutGuideConstraint = "kIQLayoutGuideConstraint"


public extension UIViewController {

    /**
    To set customized distance from keyboard for textField/textView. Can't be less than zero
    */
    @IBOutlet public var IQLayoutGuideConstraint: NSLayoutConstraint? {
        get {
            
            return objc_getAssociatedObject(self, &kIQLayoutGuideConstraint) as? NSLayoutConstraint
        }

        set(newValue) {
            objc_setAssociatedObject(self, &kIQLayoutGuideConstraint, newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}