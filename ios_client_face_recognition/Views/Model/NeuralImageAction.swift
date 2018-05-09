import UIKit


class NeuralImageAction {
    let image: UIImage
    let name: String
    let action: ImageAction
    
    
    init (image: UIImage, name: String, action: @escaping ImageAction) {
        self.image = image
        self.name = name
        self.action = action
    }
}
