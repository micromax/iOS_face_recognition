import UIKit
import Moya

class ImageActionPresenter: NeuralRequests {
    private let view: ImageActionViewController
    
    var controller: CommonViewController {
        return view
    }
    
    var neuralApi = MoyaProvider<FaceRecognitionService>()
    
    
    init(view: ImageActionViewController) {
        self.view = view
    }
    
    
    func signWithBearerToken(token: String) {
        let authPlugin = AccessTokenPlugin(tokenClosure: token)
        neuralApi = MoyaProvider<FaceRecognitionService>(plugins: [authPlugin])
    }
    
    
    func showCroppedFace(photo: UIImage) {
        self.view.view.showLoaderFullScreen()
        
        cropFace(photo) { face, faceType in
            self.actionAsyncAfterLoaderClosed {
                self.view.showImageFullScreen(face, title: "Cropped face")
            }
        }
    }
    
    
    func authorizeAfterCheck(photo: UIImage) {
        checkCroppedFaceWithAlert(photo) { _ in
            self.authorize(photo: photo)
        }
    }
    
    
    private func authorize(photo: UIImage) {
        self.view.view.showLoaderFullScreen()
        
        requestTemplate(request: .authorizePerson(image: photo)) { json in
            guard let data = json["data"] as? [String: Any] else {
                self.alertAsync(title: "Error", description: "Couldn't parse answer")
                return
            }
            
            let max_prob = Double(data["max_probability"] as? String ?? "-1")
            let matched_str = (data["matched"] as? String) ?? "false"
    
            var message = (data["message"] as? String) ?? "Access granted - \(matched_str)"
            
            if let max_prob_N = max_prob {
                message += ". Max prob = \(max_prob_N)"
            }
            
            let title = matched_str.toBool() ? "Identified" : "Not identified"
            self.alertAsync(title: title, description: message)
        }
    }
    
    
    func highlightFaces(photo: UIImage) {
        simpleImageRequest(request: .highlightFaces(image: photo), title: "Found faces")
    }
    
    
    func identifyGroup(photo: UIImage) {
        simpleImageRequest(request: .identifyGroup(image: photo), title: "Identified group")
    }
    
    
    private func simpleImageRequest(request: FaceRecognitionService, title: String = "") {
        self.view.view.showLoaderFullScreen()
        
        requestTemplate(request: request) { json in
            guard let data = json["data"] as? [String: Any],
                let imageUrl = data["image_url"] as? String else {
                    self.alertAsync(title: "Error", description: "No image in response found")
                    return
            }
            
            self.downloadImageFromUrl(url: imageUrl, action: { image in
                self.actionAsyncAfterLoaderClosed {
                    self.view.showImageFullScreen(image, title: title)
                }
            }) {
                self.alertAsync(title: "Error", description: "Couldn't download image from the internet")
            }
        }
    }
}
