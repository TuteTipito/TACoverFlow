import UIKit

class CoverflowItemCellBar : CALayer {
    private var line : CALayer = CALayer()
    private var triangle : CAShapeLayer = CAShapeLayer()
    private var text : CATextLayer = CATextLayer()
    
    private let maxHeight : CGFloat = 25
    private let lineHeight : CGFloat = 6
    
    private let textRightSpace : CGFloat = 5
    
    private let triangleHeight : CGFloat = 20
    private let triangleWidth : CGFloat = 30
    
    private let indicatorWidth : CGFloat = 30
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    // MARK: Private methods.
    
    private func setup() {
        let path : UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: triangleHeight))
        
        path.addCurve(
            to: CGPoint(x: triangleWidth, y: 0),
            controlPoint1: CGPoint(x: triangleWidth * 0.6, y: triangleHeight),
            controlPoint2: CGPoint(x: triangleWidth - (triangleWidth * 0.6), y: 0)
        )
        path.addLine(to: CGPoint(x: triangleWidth, y: triangleHeight))
        path.addLine(to: CGPoint(x: 0, y: triangleHeight))
        
        triangle.frame = CGRect(x: 0, y: 0, width: indicatorWidth, height: maxHeight - lineHeight)
        triangle.path = path.cgPath
        triangle.isHidden = true
        
//        text.font = UIFont.bodySmall()
        text.contentsScale = UIScreen.main.scale
        text.isHidden = true
        
        addSublayer(line)
        addSublayer(triangle)
        addSublayer(text)
    }
    
    // MARK: Public methods.
    
    func set(frame recFrame : CGRect) {
        frame = CGRect(x: 0, y: recFrame.height - maxHeight,
                       width: recFrame.width, height: maxHeight
        )
        line.frame = CGRect(x: 0, y: frame.height - lineHeight,
                            width: frame.width, height: lineHeight
        )
    }
    
    func set(color baseColor : UIColor) {
        line.backgroundColor = baseColor.cgColor
        text.backgroundColor = baseColor.cgColor
        triangle.fillColor = baseColor.cgColor
    }
    
    func set(text textBuffer : String) {
        let label : UILabel = UILabel()
        label.text = textBuffer
//        label.font = UIFont.bodySmall()
        label.sizeToFit()
        
        let labelWidth : CGFloat = label.frame.width + textRightSpace
        
        let myAttributes = [
//            NSFontAttributeName: UIFont.bodySmall(),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let myAttributedString = NSAttributedString(string: textBuffer, attributes: myAttributes)
        
        text.frame = CGRect(x: frame.width - labelWidth, y: 0, width: labelWidth, height: triangleHeight)
        text.string = myAttributedString
        
        triangle.frame.origin = CGPoint(x: frame.width + 1 - labelWidth - triangleWidth, y: 0)
    }
    
    func showPoints(state : Bool) {
        CATransaction.setDisableActions(true)
        text.isHidden = state
        triangle.isHidden = state
        CATransaction.setDisableActions(false)
    }
}
