import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(Float(red) / 255),
                  green: CGFloat(Float(green) / 255),
                  blue: CGFloat(Float(blue) / 255),
                  alpha: alpha)
    }
}
