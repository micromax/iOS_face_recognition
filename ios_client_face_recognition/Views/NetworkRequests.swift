import UIKit
import Moya
import Alamofire


typealias ImageAction = (UIImage) -> ()
typealias FaceAction = (UIImage, FaceType) -> ()


protocol NeuralRequests {
    var controller: CommonViewController {get}
    var neuralApi: MoyaProvider<FaceRecognitionService> {get set}
    func actionAsyncAfterLoaderClosed(action: @escaping () -> ())
    func alertAsync(title: String, description: String)
}


extension NeuralRequests {
    func success(_ json: [String: Any]) -> Bool {
        return json["status"] as? String == "success"
    }
    
    
    func actionAsyncAfterLoaderClosed(action: @escaping () -> ()) {
        DispatchQueue.main.async {
            self.controller.view.removeLoaderFullScreen() {
                action()
            }
        }
    }
    
    
    func alertAsync(title: String, description: String) {
        actionAsyncAfterLoaderClosed {
            self.controller.alert(title: title, description: description)
        }
    }
    
    
    //download cropped face and
    //give to user to choose whether it's his photo or not
    func checkCroppedFaceWithAlert(_ photo: UIImage, validFaceAction: @escaping ImageAction) {
        controller.view.showLoaderFullScreen()
        
        cropFace(photo) { face, faceType in
            self.actionAsyncAfterLoaderClosed {
                 self.controller.alertWithFace(faceType: faceType, face: face, yesAction: validFaceAction)
            }
        }
    }

    
    func checkCroppedFaceWithAlert(_ photo: UIImage, validFaceAction: @escaping FaceAction) {
        controller.view.showLoaderFullScreen()
        
        cropFace(photo) { face, faceType in
            self.actionAsyncAfterLoaderClosed {
                self.controller.alertWithFace(faceType: faceType, face: face, yesAction: validFaceAction)
            }
        }
    }
    

    //get cropped face url from server API, download it
    //it does not activate loader full screen and doesn't set it off on
    //normal function output, so you'll have to close it manually
    //after all work is done using actions as params
    func cropFace(_ photo: UIImage, onImageDownloaded: @escaping FaceAction) {
        requestTemplate(request: .nonTokenCropFace(image: photo)) { json in
            guard let data = json["data"] as? [String: Any],
                let faceTypeRaw = data["face_type"] as? String,
                let imageUrl = data["image_url"] as? String else {
                    fatalError()
            }
            
            let faceType = FaceType.init(rawValue: faceTypeRaw) ?? FaceType.center
            
            self.downloadImageFromUrl(url: imageUrl, action: { face in
                onImageDownloaded(face, faceType)
            }) {
                self.alertAsync(title: "Error", description: "Couldn't download image")
            }
        }
    }
    
    
    //None of the methods is used in main thread.
    //To use UI you should wrap into main queue yourself
    func downloadImageFromUrl(url: String,
                              action: @escaping (UIImage) -> (),
                              error: @escaping () -> ()) {
        Alamofire.request(url).responseData { response in
            if let data = response.result.value,
                let image = UIImage(data: data), response.error == nil {
                action(image)
            } else {
                error()
            }
        }
    }
    
    
    func requestTemplate(request: FaceRecognitionService,
                         onError: (([String: Any]) -> ())? = nil,
                         onFailure: (() -> ())? = nil,
                         _ onSuccess: @escaping ([String: Any]) -> ()) {
        neuralApi.request(request) { result in
            switch result {
            case let .success(response):
                guard let jsonMap = try? response.mapJSON(),
                    let json = jsonMap as? [String: Any] else {
                        self.alertAsync(title: "Error", description: "Couldn't parse data from response")
                        return
                }
                
                if self.success(json) {
                    onSuccess(json)
                } else {
                    if let error = onError {
                        error(json)
                    } else {
                        let message = json["message"] as? String ?? "Unexpected error"
                        self.alertAsync(title: "Error", description: message)
                    }
                }
                
            case let .failure(error):
                if let failure = onFailure {
                    self.actionAsyncAfterLoaderClosed(action: failure)
                } else {
                    self.alertAsync(title: "Error", description: "Couldn't get response from the server")
                    print(error)
                }
            }
        }
    }
}
