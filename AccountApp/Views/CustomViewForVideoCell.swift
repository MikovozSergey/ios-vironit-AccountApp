import UIKit
import AVFoundation

class CustomViewForVideoCell: UICollectionViewCell {
    
    static let identifier = "CustomViewForVideoCell"
    let imageView = UIImageView()
    
    var player: AVPlayer?
    var playing = true
    
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
    
    public func configure(with video: URL) {
        setupConstraint()
        configureVideo(with: video)
        
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
    
    private func configureVideo(with url: URL) {
        player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restartVideo),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspect
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        contentView.addGestureRecognizer(tap)
        viewOfCell.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
    }
    
    @objc func handleTap() {
        if playing {
            playing = false
            player?.pause()
        } else {
            playing = true
            player?.play()
        }
    }

    @objc func restartVideo() {
        player?.pause()
        player?.currentItem?.seek(to: CMTime.zero, completionHandler: { _ in
            self.player?.play()
        })
    }
}
