import UIKit

class EntryViewController: CommonViewController {

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        navigationController?.isNavigationBarHidden = true;
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        color(UIColor.brown)
    }
}
