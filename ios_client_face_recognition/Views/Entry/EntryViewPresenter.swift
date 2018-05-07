import UIKit

class EntryViewPresenter {
    private let view: EntryViewController
    
    
    init(view: EntryViewController) {
        self.view = view
    }
    
    
    func login(username: String, password: String) {
        
    }
    
    
    func loginPhoto(photo: UIImage) {
        print("photo")
    }
    
    
    func cropFace(photo: UIImage) {
        //send POST to server, get URL
        //download image from url
        //show alert with face
        
        view.alertWithFace(photo)
    }
}
