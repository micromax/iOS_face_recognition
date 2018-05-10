import UIKit

class ImageFullScreenViewController: CommonViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let downloadButton = UIBarButtonItem(image: #imageLiteral(resourceName: "download_icon"), style: .plain,
                                             target: self, action: #selector(download))

        navigationItem.rightBarButtonItem = downloadButton
        setupNavigationBar(title: data?.1)
        bgImage(#imageLiteral(resourceName: "background"))
        setupViews()
    }
    
    
    var data: (UIImage, String)? {
        didSet {
            fullScreenImageView.image = data?.0
            navigationController?.title = data?.1
        }
    }
    
    
    private let fullScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.black.cgColor
        
        return imageView
    }()
    
    
    private func setupViews() {
        view.addSubview(fullScreenImageView)
        
        fullScreenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fullScreenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fullScreenImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        fullScreenImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    @objc private func download() {
        
    }
}
