import UIKit

extension UIView {
    private static let loaderTag = 9999
    private static let fullScreenTag = 1111
    
    
    private var loaderView: UIView? {
        return viewWithTag(UIView.loaderTag)
    }
    
    
    private var fullScreenLoader: UIView? {
        return viewWithTag(UIView.fullScreenTag)
    }
    
    
    var loaderViewIsPresented: Bool {
        return loaderView != nil
    }
    
    
    func showLoader() {
        loaderView?.removeFromSuperview()
        
        let container = UIView()
        container.tag = UIView.loaderTag
        container.backgroundColor = UIColor.lightGray
        isUserInteractionEnabled = false
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        let indicatorConrainer = UIView()
        indicatorConrainer.backgroundColor = UIColor.black
        indicatorConrainer.alpha = 0.5
        indicatorConrainer.layer.cornerRadius = 5
        indicatorConrainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(indicatorConrainer)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicatorConrainer.addSubview(indicator)
        
        let views: [String: Any] = ["container": container,
                                    "indicator": indicator]
        var cnts: [NSLayoutConstraint] = []
        
        cnts += NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: views)
        cnts += NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: views)
        cnts += [NSLayoutConstraint(item: indicatorConrainer, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 0.2, constant: 0)]
        cnts += [NSLayoutConstraint(item: indicatorConrainer, attribute: .height, relatedBy: .equal, toItem: indicatorConrainer, attribute: .width, multiplier: 1, constant: 0)]
        cnts += [NSLayoutConstraint(item: indicatorConrainer, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0)]
        cnts += [NSLayoutConstraint(item: indicatorConrainer, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0)]
        cnts += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|", options: [], metrics: nil, views: views)
        cnts += NSLayoutConstraint.constraints(withVisualFormat: "V:|[indicator]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(cnts)
        setNeedsLayout()
        bringSubview(toFront: container)
    }
    
    
    func showLoaderFullScreen() {
        loaderView?.removeFromSuperview()
        
        let container = UIView()
        container.tag = UIView.fullScreenTag
        container.backgroundColor = UIColor.black
        isUserInteractionEnabled = false
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        let indicatorConrainer = UIView()
        indicatorConrainer.backgroundColor = UIColor.black
        indicatorConrainer.layer.cornerRadius = 5
        indicatorConrainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(indicatorConrainer)
        
        let image = #imageLiteral(resourceName: "face_embbedings")
        let heartsImageView = UIImageView(image: image)
        heartsImageView.translatesAutoresizingMaskIntoConstraints = false
        heartsImageView.contentMode = .scaleAspectFill
        heartsImageView.startScaleAnimation(scaleX: 1.3, scaleY: 1.3)
        
        indicatorConrainer.addSubview(heartsImageView)
        
        container.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        heartsImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
        heartsImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        heartsImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        heartsImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        setNeedsLayout()
        bringSubview(toFront: container)
    }
    
    
    func removeLoader(_ completionHandler: (() -> ())? = nil) {
        isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.7, animations: {
            self.loaderView?.alpha = 0
        }) { _ in
            completionHandler?()
            self.loaderView?.removeFromSuperview()
        }
    }
    
    
    func removeLoaderFullScreen(_ completionHandler: (() -> ())? = nil) {
        isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.7, animations: {
            self.fullScreenLoader?.alpha = 0
        }) { _ in
            completionHandler?()
            self.fullScreenLoader?.removeFromSuperview()
        }
    }
    
    
    func removeLoaderImmediately() {
        isUserInteractionEnabled = true
        loaderView?.removeFromSuperview()
        loaderView?.alpha = 0
    }
}
