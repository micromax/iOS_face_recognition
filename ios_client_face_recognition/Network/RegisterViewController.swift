import Foundation

class RegisterViewController: CommonViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        bgImage(#imageLiteral(resourceName: "background"))
        setupViews()
    }
    
    
    private lazy var presenter = RegisterViewPresenter(view: self)
    
    
    private func setupViews() {
        
    }
}
