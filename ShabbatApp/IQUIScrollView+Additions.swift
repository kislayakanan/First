

import Foundation
import UIKit

private var kIQShouldRestoreScrollViewContentOffset = "kIQShouldRestoreScrollViewContentOffset"

public extension UIScrollView {
    
    /**
     To set customized distance from keyboard for textField/textView. Can't be less than zero
     */
    public var shouldRestoreScrollViewContentOffset: Bool {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQShouldRestoreScrollViewContentOffset) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldRestoreScrollViewContentOffset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
