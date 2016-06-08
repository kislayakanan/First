


import UIKit

public class IQTitleBarButtonItem: IQBarButtonItem {
   
    public var font : UIFont? {
    
        didSet {
            if let unwrappedFont = font {
                _titleLabel?.font = unwrappedFont
            } else {
                _titleLabel?.font = UIFont.systemFontOfSize(13)
            }
        }
    }
    
    private var _titleLabel : UILabel?
    private var _titleView : UIView?

    override init() {
        super.init()
    }
    
    init(title : String?) {

        self.init(title: nil, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        _titleView = UIView()
        _titleView?.backgroundColor = UIColor.clearColor()
        _titleView?.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        
        _titleLabel = UILabel()
        _titleLabel?.numberOfLines = 0
        _titleLabel?.textColor = UIColor.grayColor()
        _titleLabel?.backgroundColor = UIColor.clearColor()
        _titleLabel?.textAlignment = .Center
        _titleLabel?.text = title
        _titleLabel?.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        font = UIFont.systemFontOfSize(13.0)
        _titleLabel?.font = self.font
        _titleView?.addSubview(_titleLabel!)
        customView = _titleView
        enabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
