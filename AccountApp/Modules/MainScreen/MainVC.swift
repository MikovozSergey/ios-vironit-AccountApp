import UIKit

class MainViewController: UITabBarController {

    private var sessionManager: SessionManager?
    private let languageHandler = LanguageNotificationHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        navigationController?.view.tintColor = Colors.gold
    }

    private func setupSession() {
        sessionManager = SessionManager(navigation: self.navigationController!)
        sessionManager!.startTimer()
    }
}
