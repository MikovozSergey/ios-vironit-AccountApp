import CoreData
import UIKit

class FirstViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStrings()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
    }
    
    // MARK: - Setup
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.empty
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}
