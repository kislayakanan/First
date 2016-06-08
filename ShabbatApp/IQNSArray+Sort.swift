

import Foundation
import UIKit

/**
UIView.subviews sorting category.
*/
internal extension Array {
    
    ///--------------
    /// MARK: Sorting
    ///--------------
    
    /**
    Returns the array by sorting the UIView's by their tag property.
    */
    internal func sortedArrayByTag() -> [Element] {
        
        return sort({ (obj1 : Element, obj2 : Element) -> Bool in
            
            let view1 = obj1 as! UIView
            let view2 = obj2 as! UIView
            
            return (view1.tag < view2.tag)
        })
    }
    
    /**
    Returns the array by sorting the UIView's by their tag property.
    */
    internal func sortedArrayByPosition() -> [Element] {
        
        return sort({ (obj1 : Element, obj2 : Element) -> Bool in
            
            let view1 = obj1 as! UIView
            let view2 = obj2 as! UIView
            
            let x1 = CGRectGetMinX(view1.frame)
            let y1 = CGRectGetMinY(view1.frame)
            let x2 = CGRectGetMinX(view2.frame)
            let y2 = CGRectGetMinY(view2.frame)
            
            if y1 != y2 {
                return y1 < y2
            } else {
                return x1 < x2
            }
        })
    }
}

