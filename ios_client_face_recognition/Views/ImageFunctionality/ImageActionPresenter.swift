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
}
