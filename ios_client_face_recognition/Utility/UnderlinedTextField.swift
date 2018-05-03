import UIKit

class UnderlinedTextField: UITextField {
    
    fileprivate var xOffset: CGFloat = 0
    fileprivate var yOffset: CGFloat = 0
    
    
    convenience init(xOffset: CGFloat, yOffset: CGFloat) {
        self.init()
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createUnderline(layer: layer, frame: frame)
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: xOffset, dy: yOffset)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: xOffset, dy: yOffset)
    }
}


private func createUnderline(layer: CALayer, frame: CGRect) {
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = UIColor.lightGray.cgColor
    border.frame = CGRect(x: 0, y: frame.size.height - width,
                          width:  frame.size.width, height: frame.size.height)
    
    border.borderWidth = width
    layer.addSublayer(border)
    layer.masksToBounds = true
}
