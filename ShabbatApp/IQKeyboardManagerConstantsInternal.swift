


import Foundation

///-----------------------------------
/// MARK: IQLayoutGuidePosition
///-----------------------------------

/**
`IQLayoutGuidePositionNone`
If there are no IQLayoutGuideConstraint associated with viewController

`IQLayoutGuidePositionTop`
If provided IQLayoutGuideConstraint is associated with with viewController topLayoutGuide

`IQLayoutGuidePositionBottom`
If provided IQLayoutGuideConstraint is associated with with viewController bottomLayoutGuide
*/
public enum IQLayoutGuidePosition : Int {
    case None
    case Top
    case Bottom
}
