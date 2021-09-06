import UIKit

class MainViewController: UITabBarController {

    private var sessionManager: SessionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        setupUI()
        setupTapBarTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.barTintColor = Theme.currentTheme.backgroundColor
    }
    
    private func setupUI() {
        navigationController?.view.tintColor = Colors.gold
    }

    private func setupSession() {
        sessionManager = SessionManager(navigation: self.navigationController!)
        sessionManager!.startTimer()
    }
    
    private func setupTapBarTitle() {
        let tabBarItemEmpty = tabBar.items![0]
        let tabBarItemSettings = tabBar.items![2]
        self.tabBarController?.tabBar.items?[1].title = "tab title"
        tabBarItemEmpty.title = L10n.empty
        tabBarItemSettings.title = L10n.settings
    }
}
