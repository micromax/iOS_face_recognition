import UIKit
import Alamofire

extension UITextField {
    func defaultInitilization(hint: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor.white
        let placeholder = NSAttributedString(string: hint,
                                             attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        
        self.attributedPlaceholder = placeholder
        self.textAlignment = .center
    }
}


extension UIFont{
    func withHeightConstant(multiplier: CGFloat, view: UIView) -> UIFont {
        return self.withSize(view.frame.height * multiplier)
    }
}


extension UIButton {
    func filledCornerInitilization(color: UIColor, title: String, cornerRadius: CGFloat = 20) {
        backgroundColor = color
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        layer.borderColor = color.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        
        translatesAutoresizingMaskIntoConstraints = false
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
