import UIKit


class NeuralImageAction {
    let image: UIImage
    let name: String
    let action: () -> ()
    
    
    init (image: UIImage, name: String, action: @escaping () -> ()) {
        self.image = image
        self.name = name
        self.action = action
    }
}
