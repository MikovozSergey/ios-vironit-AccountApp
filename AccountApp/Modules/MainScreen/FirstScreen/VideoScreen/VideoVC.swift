import AVFoundation
import UIKit

class VideoViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var videoView: UIView!
    
    // MARK: - Variables
    
    private var urlOfVideo: URL?
    private var player: AVPlayer?
    private var playing = true
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStrings()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        videoView.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    public func configure(with url: URL) {
        self.urlOfVideo = url
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        guard let url = urlOfVideo else { return }
        player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restartVideo),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = videoView.bounds
       // playerView.videoGravity = .resizeAspect
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        videoView.addGestureRecognizer(tap)
        videoView.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
    }
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.video
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
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
