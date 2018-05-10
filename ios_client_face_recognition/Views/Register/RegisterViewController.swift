import UIKit

class RegisterViewController: CommonViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardObserversWith(offset: 50, keyboardShowEvent: { event in
            self.animateTitleColor(UIColor.black.withAlphaComponent(0))
        }, keyboardHideEvent: { event in
            self.animateTitleColor(UIColor.black.withAlphaComponent(1))
        })
        
        registerDismissingKeyboardOnTap()
        setupNavigationBar(title: "Registration")
        bgImage(#imageLiteral(resourceName: "background"))
        setupViews()
    }
    
    
    private lazy var presenter = RegisterViewPresenter(view: self)
    
    
    private let frontImage: UIImageView = {
        let faceImage = UIImageView()
        faceImage.image = #imageLiteral(resourceName: "valakas_action_1")
        faceImage.translatesAutoresizingMaskIntoConstraints = false
        faceImage.contentMode = .scaleAspectFill
        
        return faceImage
    }()
    
    
    private let usernameTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(xOffset: 0, yOffset: 5)
        textField.defaultInitilization(hint: "Username")
        
        return textField
    }()
    
    
    private let passwordTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(xOffset: 0, yOffset: 5)
        textField.defaultInitilization(hint: "Password")
        
        return textField
    }()
    
    
    private let inputImageButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Add image")
        
        return button
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "You have to provide at least one image for each face type:"
        
        return label
    }()
    
    
    private let faceCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FaceCell.self, forCellWithReuseIdentifier: FaceCell.id)
        collectionView.backgroundColor = UIColor.clear
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.black.cgColor
        
        return collectionView
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Register")
        button.isEnabled = false
        
        return button
    }()
    
    
    private let leftFaceType: UIView = {
        let view = UILabel()
        view.text = "left"
        view.textAlignment = .center
        view.textColor = UIColor(red: 240, green: 248, blue: 255)
        
        view.backgroundColor = UIColor(red: 220, green: 20, blue: 60)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private let centerFaceType: UIView = {
        let view = UILabel()
        view.text = "center"
        view.textAlignment = .center
        view.textColor = UIColor(red: 240, green: 248, blue: 255)
        
        view.backgroundColor = UIColor(red: 220, green: 20, blue: 60)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private let rightFaceType: UIView = {
        let view = UILabel()
        view.text = "right"
        view.textAlignment = .center
        view.textColor = UIColor(red: 240, green: 248, blue: 255)
        
        view.backgroundColor = UIColor(red: 220, green: 20, blue: 60)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var faces = [UIImage]()
    private var currentFaceIndex = 0
    
    private func setupViews() {
        for _ in 0..<6 {
            faces.append(#imageLiteral(resourceName: "placeholder_image"))
        }
        
        usernameTextField.scaleFont(scale: 0.04, view: view)
        passwordTextField.scaleFont(scale: 0.04, view: view)
        descriptionLabel.scaleFont(scale: 0.04, view: view)
        inputImageButton.scaleFont(view: view)
        registerButton.scaleFont(view: view)
        
        view.addSubview(frontImage)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(inputImageButton)
        view.addSubview(registerButton)
        view.addSubview(faceCollection)
        view.addSubview(leftFaceType)
        view.addSubview(centerFaceType)
        view.addSubview(rightFaceType)
        
        frontImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frontImage.widthAnchor.constraint(equalToConstant: view.frame.width * 0.3).isActive = true
        frontImage.heightAnchor.constraint(equalToConstant: view.frame.width * 0.3).isActive = true
        frontImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        
        let offset: CGFloat = 28
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: frontImage.bottomAnchor, constant: 20).isActive = true
        
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        
        faceCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        faceCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        faceCollection.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        faceCollection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17).isActive = true
        faceCollection.delegate = self
        faceCollection.dataSource = self
        
        leftFaceType.topAnchor.constraint(equalTo: faceCollection.bottomAnchor, constant: 10).isActive = true
        leftFaceType.leadingAnchor.constraint(equalTo: faceCollection.leadingAnchor).isActive = true
        leftFaceType.widthAnchor.constraint(equalTo: faceCollection.widthAnchor, multiplier: 0.33).isActive = true
        leftFaceType.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.035).isActive = true
        
        centerFaceType.topAnchor.constraint(equalTo: faceCollection.bottomAnchor, constant: 10).isActive = true
        centerFaceType.leadingAnchor.constraint(equalTo: leftFaceType.trailingAnchor).isActive = true
        centerFaceType.widthAnchor.constraint(equalTo: leftFaceType.widthAnchor).isActive = true
        centerFaceType.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.035).isActive = true
        
        rightFaceType.topAnchor.constraint(equalTo: faceCollection.bottomAnchor, constant: 10).isActive = true
        rightFaceType.leadingAnchor.constraint(equalTo: centerFaceType.trailingAnchor).isActive = true
        rightFaceType.widthAnchor.constraint(equalTo: leftFaceType.widthAnchor).isActive = true
        rightFaceType.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.035).isActive = true
        
        inputImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        inputImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        inputImageButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -15).isActive = true
        inputImageButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075).isActive = true
        inputImageButton.addTarget(self, action: #selector(onAddImageClick), for: .touchUpInside)
        
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.05).isActive = true
        registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075).isActive = true
        registerButton.addTarget(self, action: #selector(onRegisterClick), for: .touchUpInside)
    }
    
    
    @objc private func onAddImageClick() {
        faces[currentFaceIndex] = #imageLiteral(resourceName: "placeholder_image")
        
        faceCollection.reloadItems(at: [IndexPath(row: currentFaceIndex, section: 0)])
        currentFaceIndex += 1
    }
    
    
    @objc private func onRegisterClick() {
        
    }
}


extension RegisterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faces.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FaceCell.id, for: indexPath)
            as? FaceCell else {
            fatalError()
        }
        
        cell.face = faces[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}
