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
    
    
    func showCroppedFace(photo: UIImage) {
        checkCroppedFaceWithAlert(photo) { _ in }
    }
    
    
    func authorizeAfterCheck(photo: UIImage) {
        checkCroppedFaceWithAlert(photo) { _ in
            self.authorize(photo: photo)
        }
    }
    
    
    private func authorize(photo: UIImage) {
        
    }
    
    
    func highlightFacesAfterCheck(photo: UIImage) {
        checkCroppedFaceWithAlert(photo) { _ in
            self.highlightFaces(photo: photo)
        }
    }
    
    
    private func highlightFaces(photo: UIImage) {
        
    }
    
    
    func identifyGroupAfterCheck(photo: UIImage) {
        checkCroppedFaceWithAlert(photo) { _ in
            self.identifyGroup(photo: photo)
        }
    }
    
    
    private func identifyGroup(photo: UIImage) {
        
    }
}
