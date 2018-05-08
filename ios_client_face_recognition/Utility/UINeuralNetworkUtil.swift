import UIKit

protocol UINeuralNetworkUtil {
    func alert(title: String, description: String)
    func alertWithFace(faceType: FaceType, face: UIImage, yesAction: @escaping (UIImage) -> ())
}

extension UINeuralNetworkUtil where Self: CommonViewController {
    func alert(title: String, description: String) {
        let alert = customizedAlertController(title: title, description: description)
        let ok = customizedAlertAction(title: "OK");
        
        alert.addAction(ok);
        present(alert, animated: true)
    }
    
    
    func alertWithFace(faceType: FaceType, face: UIImage, yesAction: @escaping (UIImage) -> ()) {
        let alert = customizedAlertController(title: "Found face", description:
            "Face type = \(faceType.rawValue). Is this your face?", image: face)
        
        let yes = customizedAlertAction(title: "Yes" ) {
            yesAction(face)
        }
        let no = customizedAlertAction(title: "No")
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
}

extension CommonViewController: UINeuralNetworkUtil {}
