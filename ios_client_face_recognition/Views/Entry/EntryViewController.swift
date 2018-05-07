import UIKit


class EntryViewController: CommonViewController {

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        bgImage(UIImage(named: "background")!)
        setupViews()
    }
    
    
    private let frontImage: UIImageView = {
        let faceImage = UIImageView()
        faceImage.image = #imageLiteral(resourceName: "face_embbedings")
        faceImage.translatesAutoresizingMaskIntoConstraints = false
        faceImage.contentMode = .scaleAspectFill
        
        return faceImage
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Register")
        
        return button
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Login")
        
        return button
    }()
    
    
    private let loginPhotoButton: UIButton = {
        let button = UIButton()
        button.defaultInit(title: "Login with photo")
        
        return button
    }()
    
    
    private lazy var presenter = EntryViewPresenter(view: self)
    
    
    @objc private func login() {
        let alert = customizedAlertController(title: "Input data", description: "Username and password");
        
        alert.addTextField({textField in
            textField?.defaultInitilization(hint: "Username")
            textField?.scaleFont(view: self.view)
        })
        alert.addTextField({textField in
            textField?.defaultInitilization(hint: "Password")
            textField?.scaleFont(view: self.view)
        })
        
        let ok = customizedAlertAction(title: "OK", action: {
            let usernameTextField = alert.textFields[0]
            let passwordTextField = alert.textFields[1]
            
            guard let username = usernameTextField.text,
                let password = passwordTextField.text else {
                    self.dismiss(animated: true, completion: nil)
                return
            }
            
            if !username.isEmpty && !password.isEmpty {
                self.presenter.login(username: username, password: password)
            }
        });
        
        let cancel = customizedAlertAction(title: "Cancel");
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    
    func alert(title: String, description: String) {
        let alert = customizedAlertController(title: title, description: description)
        let ok = customizedAlertAction(title: "OK");
        
        alert.addAction(ok);
        present(alert, animated: true)
    }
    
    
    func alertWithFace(_ face: UIImage) {
        let alert = customizedAlertController(title: "Found face", description: "Is this your face?", image: face)
        
        let yes = customizedAlertAction(title: "Yes" , action: {
            self.presenter.loginPhoto(photo: face)
        });
        let no = customizedAlertAction(title: "No")
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
    
    
    @objc private func loginPhoto() {
        pickImageActionSheet(action: chooseImageWith)
    }
    
    
    private func chooseImageWith(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    
    @objc private func register() {
        let registerVC = RegisterViewController()
        
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    private func setupViews() {
        view.addSubview(frontImage)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        view.addSubview(loginPhotoButton)
        
        registerButton.scaleFont(view: view)
        loginButton.scaleFont(view: view)
        loginPhotoButton.scaleFont(view: view)
        
        let offset: CGFloat = 30
        
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        registerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.085).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height / 15)).isActive = true
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        loginPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        loginPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        loginPhotoButton.heightAnchor.constraint(equalTo: registerButton.heightAnchor).isActive = true
        loginPhotoButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -15).isActive = true
        loginPhotoButton.addTarget(self, action: #selector(loginPhoto), for: .touchUpInside)
        
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset).isActive = true
        loginButton.heightAnchor.constraint(equalTo: registerButton.heightAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: loginPhotoButton.topAnchor, constant: -20).isActive = true
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        
        frontImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frontImage.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        frontImage.heightAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        frontImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
    }
}


extension EntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true, completion: {
            self.presenter.cropFace(photo: image)
        });
    }
}
