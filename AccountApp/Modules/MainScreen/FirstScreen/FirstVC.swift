import CoreData
import UIKit

class FirstViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
        handleLanguage()
    }
    
    private func setupTheme() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        navigationController?.navigationBar.topItem?.title = L10n.empty
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    private func setupUI() {
        setupStrings()
    }
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.empty
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}
