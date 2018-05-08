import UIKit
import Alamofire

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}


extension UITextField {
    func defaultInitilization(hint: String, color: UIColor = UIColor.black, bgColor: UIColor? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = color
        let placeholder = NSAttributedString(string: hint,
                                             attributes: [NSAttributedStringKey.foregroundColor : color])
        
        self.attributedPlaceholder = placeholder
        self.textAlignment = .center
        self.backgroundColor = UIColor(red: 240, green: 248, blue: 255)
    }
    
    
    func scaleFont(scale: CGFloat = 0.035, view: UIView) {
        font = font?.withSize(scale * view.frame.height)
    }
}


extension UIFont{
    func withHeightConstant(multiplier: CGFloat, view: UIView) -> UIFont {
        return self.withSize(view.frame.height * multiplier)
    }
}


extension UIButton {
    func defaultInit(title: String, color: UIColor = UIColor.white) {
        backgroundColor = UIColor(red: 96, green: 134, blue: 196)
        setTitle(title, for: . normal)
        setTitleColor(color, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func scaleFont(scale: CGFloat = 0.035, view: UIView) {
        titleLabel?.font = titleLabel?.font.withSize(scale * view.frame.height)
    }
}



fileprivate var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func startScaleAnimation(scaleX: CGFloat, scaleY: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.repeat, .autoreverse],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        })
    }
    
    
    func stopAnimations() {
        layer.removeAllAnimations()
    }
    
    
    func downloadImageFrom(url: String) {
        if let cachedImage = imageCache.object(forKey: NSString(string: url)) {
            self.image = cachedImage
            return
        }
        
        showLoader()
        
        Alamofire.request(url).responseData { [unowned self] response -> Void in
            if let data = response.result.value,
                let image = UIImage(data: data),
                response.error == nil {
                
                DispatchQueue.main.async { [unowned self] () -> Void in
                    self.image = image
                    imageCache.setObject(image, forKey: NSString(string: url))
                    self.removeLoader()
                }
            } else {
                self.removeLoader()
            }
        }
    }
}


extension UIView {
    func fadeAnimation(toAlpha: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) { [unowned self] () -> Void in
            self.alpha = toAlpha
        }
    }
}
