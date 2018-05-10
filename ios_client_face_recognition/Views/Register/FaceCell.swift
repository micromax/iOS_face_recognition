import UIKit


class FaceCell: UICollectionViewCell {
    static let id = "face_cell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    var face: UIImage? {
        didSet {
            faceView.image = face
        }
    }
    
    
    private let faceView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 3
        
        return imageView
    }()
    
    
    private func setupViews() {
        addSubview(faceView)
        
        faceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
        faceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        faceView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        faceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
    }
}
