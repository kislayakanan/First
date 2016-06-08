

import UIKit

/** @abstract UITextView with placeholder support   */
public class IQTextView : UITextView {

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextViewTextDidChangeNotification, object: self)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    override public func awakeFromNib() {
         super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var placeholderLabel: UILabel?
    
    /** @abstract To set textView's placeholder text. Default is ni.    */
    public var placeholder : String? {

        get {
            return placeholderLabel?.text
        }
 
        set {
            
            if placeholderLabel == nil {
                
                placeholderLabel = UILabel()
                
                if let unwrappedPlaceholderLabel = placeholderLabel {
                    
                    unwrappedPlaceholderLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                    unwrappedPlaceholderLabel.lineBreakMode = .ByWordWrapping
                    unwrappedPlaceholderLabel.numberOfLines = 0
                    unwrappedPlaceholderLabel.font = self.font
                    unwrappedPlaceholderLabel.backgroundColor = UIColor.clearColor()
                    unwrappedPlaceholderLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
                    unwrappedPlaceholderLabel.alpha = 0
                    addSubview(unwrappedPlaceholderLabel)
                }
            }
            
            placeholderLabel?.text = newValue
            refreshPlaceholder()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let unwrappedPlaceholderLabel = placeholderLabel {
            unwrappedPlaceholderLabel.sizeToFit()
            unwrappedPlaceholderLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame)-16, CGRectGetHeight(unwrappedPlaceholderLabel.frame))
        }
    }

    public func refreshPlaceholder() {
        
        if text.characters.count != 0 {
            placeholderLabel?.alpha = 0
        } else {
            placeholderLabel?.alpha = 1
        }
    }
    
    override public var text: String! {
        
        didSet {
            
            refreshPlaceholder()

        }
    }
    
    override public var font : UIFont? {
       
        didSet {
            
            if let unwrappedFont = font {
                placeholderLabel?.font = unwrappedFont
            } else {
                placeholderLabel?.font = UIFont.systemFontOfSize(12)
            }
        }
    }
    
    override public var delegate : UITextViewDelegate? {
        
        get {
            refreshPlaceholder()
            return super.delegate
        }
        
        set {
            
        }
    }
}


