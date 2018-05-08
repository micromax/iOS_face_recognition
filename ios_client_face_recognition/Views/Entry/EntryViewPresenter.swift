import UIKit
import Moya

class EntryViewPresenter: NeuralRequests {
    private let view: EntryViewController
    
    var controller: CommonViewController {
        return view
    }
    
    var neuralApi = MoyaProvider<FaceRecognitionService>()
    
    
    init(view: EntryViewController) {
        self.view = view
    }
    
    
    func login(username: String, password: String) {
        neuralApi.request(.login(username: username, password: password)) { result in
            self.view.view.showLoaderFullScreen()
            
            switch result {
            case let .success(response):
                guard let mapJson = try? response.mapJSON(),
                    let json = mapJson as? [String: Any] else {
                    return
                }
                
                if self.success(json) {
                    guard let data = json["data"] as? [String: Any],
                        let token = data["Authorization"] as? String else {
                        fatalError("Couldn't parse token")
                    }
                    
                    self.actionAsyncAfterLoaderClosed {
                        self.view.onLogin(username: username, token: token)
                    }
                } else {
                    let message = json["message"] as? String ?? "Unexpected error."
                    self.alertAsync(title: "Unable to login", description: message)
                }
            case let .failure(error):
                self.alertAsync(title: "Error", description: "Couldn't send request")
                print(error)
            }
        }
    }
    
    
    func loginPhotoAfterFaceCheck(photo: UIImage) {
        //first we give cropped face to user
        //so he can approve taken image
        //then we send login
        checkCroppedFaceWithAlert(photo) { _ in
            //we have to use full photo instead of cropped one
            self.requestloginPhoto(image: photo)
        }
    }
    
    
    func requestloginPhoto(image: UIImage) {
        self.view.view.showLoaderFullScreen()
        
        neuralApi.request(.loginPhoto(image: image)) { result in
            switch result {
            case let .success(response):
                guard let mapJson = try? response.mapJSON(),
                    let json = mapJson as? [String: Any] else {
                        return
                }
                
                if self.success(json) {
                    guard let data = json["data"] as? [String: Any] else {
                            fatalError("Couldn't parse data")
                    }
                    
                    let matchedStr = data["matched"] as? String
                    let matched = matchedStr?.toBool() ?? false
                    let probability = data["max_probability"] as? String ?? "0"
                    
                    if (matched) {
                        let username = data["username"] as? String ?? "none"
                        guard let token = data["Authorization"] as? String else { fatalError() }
                        self.actionAsyncAfterLoaderClosed {
                            self.view.onLogin(username: username, token: token)
                        }
                    } else {
                        self.actionAsyncAfterLoaderClosed {
                            self.alertAsync(title: "Not matched", description:
                                "Not authorized. Max prob = \(probability)%.")
                        }
                    }
                } else {
                    let message = json["message"] as? String ?? "Unexpected error."
                    self.alertAsync(title: "Unable to login", description: message)
                }
            case let .failure(error):
                self.alertAsync(title: "Error", description: "Couldn't send request")
                print(error)
            }
        }
    }
}
