import UIKit
import Moya
import UIView_Shake

class RegisterViewPresenter: NeuralRequests {
    var controller: CommonViewController {
        return view
    }
    
    var neuralApi = MoyaProvider<FaceRecognitionService>()
    
    private let view: RegisterViewController
    private var faceTypesGiven = [FaceType]()
    
    
    init(view: RegisterViewController) {
        self.view = view
    }
    
    
    func checkCroppedFace(_ photo: UIImage) {
        checkCroppedFaceWithAlert(photo) { face, faceType in
            self.view.addFace(face)
            self.view.fullImages.append(photo)
            
            if !self.faceTypesGiven.contains(faceType) {
                self.faceTypesGiven.append(faceType)
                self.enableFaceType(faceType)
                
                if self.areAllFaceTypesGiven() {
                    self.enableRegister()
                }
            }
        }
    }
    
    
    func register() {
        if let username = view.usernameTextField.text,
            let password = view.passwordTextField.text,
                !username.isEmpty, !password.isEmpty {
            view.view.showLoaderFullScreen()
            
            requestTemplate(request: .register(username: username, password: password, faces: view.fullImages)) { json in
                self.actionAsyncAfterLoaderClosed {
                    self.view.onSuccessfullRegister()
                }
            }
        } else {
            view.usernameTextField.shake(3, withDelta: 8, speed: 0.05)
            view.passwordTextField.shake(3, withDelta: 8, speed: 0.05)
        }
    }
    
    
    private func enableFaceType(_ type: FaceType) {
        let color = UIColor.green
        
        switch type {
        case .center:
            view.centerFaceTypeView.textColor = UIColor.black
            view.centerFaceTypeView.fadeColor(color, duration: 2)
        case .left:
            view.leftFaceTypeView.textColor = UIColor.black
            view.leftFaceTypeView.fadeColor(color, duration: 2)
        case.right:
            view.rightFaceTypeView.textColor = UIColor.black
            view.rightFaceTypeView.fadeColor(color, duration: 2)
        }
    }
    
    private func enableRegister() {
        view.registerButton.isEnabled = true
        view.registerButton.alpha = 1
    }
    
    
    private func areAllFaceTypesGiven() -> Bool {
        return faceTypesGiven.contains(.center)
            && faceTypesGiven.contains(.right)
            && faceTypesGiven.contains(.left)
    }
}
