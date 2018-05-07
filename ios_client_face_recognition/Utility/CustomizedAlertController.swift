import PMAlertController


extension UIViewController {
    func customizedAlertController(title: String, description: String, image: UIImage? = nil) -> PMAlertController {
        let alert = PMAlertController(title: title, description: description, image: image, style: .alert)
        if image != nil {
            alert.alertImage.backgroundColor = UIColor(red: 219, green: 220, blue: 213)
        }
        
        alert.alertTitle.font = alert.alertTitle.font.withHeightConstant(multiplier: 0.045, view: view)
        alert.alertDescription.font = alert.alertTitle.font.withHeightConstant(multiplier: 0.035, view: view)
        alert.alertViewWidthConstraint.constant = view.frame.width * 0.85
        alert.alertView.backgroundColor = UIColor(red: 219, green: 220, blue: 213)
        
        alert.alertDescription.textColor = UIColor.black.withAlphaComponent(0.8)
        alert.alertTitle.textColor = UIColor.black
        
        return alert
    }
    
    
    func customizedAlertAction(title: String?, action: (() -> Void)? = nil) -> PMAlertAction {
        let action = PMAlertAction(title: title, style: .default, action: action)
        action.titleLabel?.font = action.titleLabel?.font.withHeightConstant(multiplier: 0.038, view: view)
        action.setTitleColor(UIColor(red: 39, green: 128, blue: 245), for: .normal)
        action.separator.backgroundColor = UIColor(red: 140, green: 140, blue: 140)
        
        return action
    }
    
    
    func pickImageActionSheet(action: @escaping ((UIImagePickerControllerSourceType) -> ())) {
        let alert = UIAlertController(title: "Choose an image", message: "There should be faces.", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            action(.camera)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            action(.photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        alert.addAction(galleryAction)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
