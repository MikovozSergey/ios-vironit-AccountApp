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
        setupTabBar()
    }
    
    private func setupUI() {
        navigationController?.view.tintColor = Colors.gold
    }
    
    private func setupTabBar() {
//        self.tabBar.isTranslucent = true
//        self.tabBar.barTintColor = Theme.currentTheme.backgroundColor
    }

    private func setupSession() {
        sessionManager = SessionManager(navigation: self.navigationController!)
        sessionManager!.startTimer()
    }
}
