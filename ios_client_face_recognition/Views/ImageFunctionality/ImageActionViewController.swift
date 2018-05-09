import UIKit


class ImageActionViewController: CommonViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: username)
        
        bgImage(#imageLiteral(resourceName: "background"))
        setupActionData()
        setupViews()
    }
    
    
    private let actionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(ImageActionCell.self, forCellWithReuseIdentifier: ImageActionCell.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    
    private lazy var presenter = ImageActionPresenter(view: self)
    private var imageActions = [NeuralImageAction]()
    
    var username: String?
    var token: String?
    
    
    private func setupActionData() {
        imageActions.append(NeuralImageAction(image: #imageLiteral(resourceName: "valakas_action_2"), name: "Authorize", action: presenter.authorizeAfterCheck))
        imageActions.append(NeuralImageAction(image: #imageLiteral(resourceName: "valakas_action_2"), name: "Find faces", action: presenter.highlightFacesAfterCheck))
        imageActions.append(NeuralImageAction(image: #imageLiteral(resourceName: "valakas_action_2"), name: "Identify group", action: presenter.identifyGroupAfterCheck))
        imageActions.append(NeuralImageAction(image: #imageLiteral(resourceName: "valakas_action_2"), name: "Crop face", action: presenter.showCroppedFace))
        imageActions.append(NeuralImageAction(image: #imageLiteral(resourceName: "valakas_action_2"), name: "Customize", action: nonSupportedAction))
        imageActions.append(NeuralImageAction(image: #imageLiteral(resourceName: "valakas_action_2"), name: "Update photo", action: nonSupportedAction))
    }
    
    
    private func setupViews() {
        view.addSubview(actionCollectionView)
        
        actionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        actionCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        actionCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        actionCollectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        actionCollectionView.delegate = self
        actionCollectionView.dataSource = self
    }
    
    
    private func nonSupportedAction(image: UIImage) {
        alert(title: "Not supported.", description: "Try using it in later releases.")
    }
}



extension ImageActionViewController: UICollectionViewDelegate, UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageActions.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageActionCell.id, for: indexPath)
            as? ImageActionCell else {
            fatalError()
        }
        cell.imageAction = imageActions[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width * 0.5 - 5
        let height = collectionView.frame.height / (CGFloat(imageActions.count) * 0.5)
    
        return CGSize(width: size, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageActionCell else {
            fatalError()
        }
        
        cell.onTap()
    }
}
