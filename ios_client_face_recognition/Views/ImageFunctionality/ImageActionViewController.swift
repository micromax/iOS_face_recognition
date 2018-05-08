import UIKit


class ImageActionViewController: CommonViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: username)
        
        bgImage(#imageLiteral(resourceName: "background"))
        setupViews()
    }
    
    private lazy var presenter = ImageActionPresenter(view: self)
    var username: String?
    var token: String?
    
    
    func setupViews() {
        
    }
}
