import UIKit
import CoreData

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
    
    
    private let frontImage: UIImageView = {
        let faceImage = UIImageView()
        faceImage.image = #imageLiteral(resourceName: "valakas_action_1")
        faceImage.translatesAutoresizingMaskIntoConstraints = false
        faceImage.contentMode = .scaleAspectFill
        
        return faceImage
    }()
    
    
    let usernameTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(xOffset: 0, yOffset: 5)
        textField.defaultInitilization(hint: "Username")
        
        return textField
    }()
    
    
    let passwordTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(xOffset: 0, yOffset: 5)
        textField.defaultInitilization(hint: "Password")
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    
    private let inputImageButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Add image")
        
        return button
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
    
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Register")
        button.isEnabled = false
        button.alpha = 0.5
        
        return button
    }()
    
    
    var leftFaceTypeView: UILabel!
    var centerFaceTypeView: UILabel!
    var rightFaceTypeView: UILabel!
    
    
    private lazy var presenter = RegisterViewPresenter(view: self)
    private var faces = [UIImage]()
    private var currentFaceIndex = 0
    
    var fullImages = [UIImage]()
    
    
    private func setupViews() {
        for _ in 0..<6 {
            faces.append(#imageLiteral(resourceName: "placeholder_image"))
        }
        
        usernameTextField.scaleFont(scale: 0.04, view: view)
        passwordTextField.scaleFont(scale: 0.04, view: view)
        inputImageButton.scaleFont(view: view)
        registerButton.scaleFont(view: view)
        
        view.addSubview(frontImage)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(inputImageButton)
        view.addSubview(registerButton)
        view.addSubview(faceCollection)
        
        leftFaceTypeView = spawnFaceTypeLabel(text: "left")
        rightFaceTypeView = spawnFaceTypeLabel(text: "right")
        centerFaceTypeView = spawnFaceTypeLabel(text: "center")
        view.addSubview(leftFaceTypeView)
        view.addSubview(centerFaceTypeView)
        view.addSubview(rightFaceTypeView)
        
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
        
        leftFaceTypeView.topAnchor.constraint(equalTo: faceCollection.bottomAnchor, constant: 10).isActive = true
        leftFaceTypeView.leadingAnchor.constraint(equalTo: faceCollection.leadingAnchor).isActive = true
        leftFaceTypeView.widthAnchor.constraint(equalTo: faceCollection.widthAnchor, multiplier: 0.33).isActive = true
        leftFaceTypeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.035).isActive = true
        
        centerFaceTypeView.topAnchor.constraint(equalTo: faceCollection.bottomAnchor, constant: 10).isActive = true
        centerFaceTypeView.leadingAnchor.constraint(equalTo: leftFaceTypeView.trailingAnchor).isActive = true
        centerFaceTypeView.widthAnchor.constraint(equalTo: leftFaceTypeView.widthAnchor).isActive = true
        centerFaceTypeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.035).isActive = true
        
        rightFaceTypeView.topAnchor.constraint(equalTo: faceCollection.bottomAnchor, constant: 10).isActive = true
        rightFaceTypeView.leadingAnchor.constraint(equalTo: centerFaceTypeView.trailingAnchor).isActive = true
        rightFaceTypeView.widthAnchor.constraint(equalTo: leftFaceTypeView.widthAnchor).isActive = true
        rightFaceTypeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.035).isActive = true
        
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
    
    
    private func spawnFaceTypeLabel(text: String) -> UILabel {
        let view = UILabel()
        view.text = text
        view.textAlignment = .center
        view.textColor = UIColor(red: 240, green: 248, blue: 255)
        
        view.backgroundColor = UIColor(red: 220, green: 20, blue: 60)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    
    @objc private func onAddImageClick() {
        pickImageActionSheet(delegate: self)
    }
    
    
    func addFace(_ face: UIImage) {
        faces[currentFaceIndex] = face
        
        faceCollection.reloadItems(at: [IndexPath(row: currentFaceIndex, section: 0)])
        currentFaceIndex += 1
    }
    
    
    func onSuccessfullRegister() {
        let controller = customizedAlertController(title: "Success", description: "You have been registered")
        let action = customizedAlertAction(title: "OK") {
            self.navigationController?.popViewController(animated: true)
        }
        
        controller.addAction(action)
        
        present(controller, animated: true)
    }
    
    
    @objc private func onRegisterClick() {
        presenter.register()
    }
    
    
    @available(iOS 10.0, *)
    private func saveToLocalDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ImageActionData", in: context)!
        let person = NSManagedObject(entity: entity, insertInto: context)
        
        person.setValue(usernameTextField.text!, forKey: "name")
        
        guard let imageData = UIImagePNGRepresentation(faces[0]) else { return }
        person.setValue(imageData, forKey: "image")
        
        do {
            try context.save()
            print("Saved")
        } catch let error {
            print("not saved \(error)")
        }
    }
    
    @available(iOS 10.0, *)
    private func getPersonFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "ImageActionData")
        
        do {
            let arr = try context.fetch(fetch)
            print(arr.count)
        } catch let error {
            print(error)
        }
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


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError()
        }
        
        dismiss(animated: true) {
            self.presenter.checkCroppedFace(image)
        }
    }
}
