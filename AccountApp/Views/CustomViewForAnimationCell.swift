import UIKit
import AVFoundation
import Lottie

class CustomViewForAnimationCell: UICollectionViewCell {
    
    static let identifier = "CustomViewForAnimationCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  //      addSubview(imageView)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewOfCell: UIView = {
       let view = UIView()
        return view
    }()
    
    public func configure(with animation: String) {
        setupConstraint()
        configureAnimation(with: animation)
    }
    
    private func addSubviews() {
        contentView.addSubview(viewOfCell)
    }
    
    private func setupConstraint() {
        viewOfCell.translatesAutoresizingMaskIntoConstraints = false

        viewOfCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        viewOfCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        viewOfCell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        viewOfCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func configureAnimation(with name: String) {
        let animationView = AnimationView(name: name)
        animationView.frame = contentView.bounds
        animationView.contentMode = .scaleAspectFit
        viewOfCell.addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
        
    }
}
