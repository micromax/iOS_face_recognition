import UIKit

class ImageActionCell: UICollectionViewCell {
    static let id = "imageActionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
    var imageAction: NeuralImageAction? {
        didSet {
            if let action = imageAction {
                visualImageView.image = action.image;
                visualLabel.text = action.name.uppercased()
            }
        }
    }
    
    
    private let visualImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    
    private let visualLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    
    private func setupViews() {
        visualLabel.scaleFont(scale: 0.11, view: self)
        
        addSubview(visualImageView)
        addSubview(visualLabel)
        
        visualLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        visualLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        visualLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        visualLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
        visualImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        visualImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        visualImageView.topAnchor.constraint(equalTo: visualLabel.bottomAnchor, constant: 0).isActive = true
        visualImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        visualImageView.layer.borderWidth = 8
        visualImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func onTap() {
        if let action = imageAction {
            action.action(action.image)
        }
    }
}
