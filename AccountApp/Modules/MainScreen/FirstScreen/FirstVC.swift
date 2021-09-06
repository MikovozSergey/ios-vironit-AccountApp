import CoreData
import UIKit

class FirstViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStrings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
    }
    
    private func setupTheme() {
        self.navigationController!.navigationBar.topItem!.title = ""
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    private func setupUI() {
        setupStrings()
    }
    
    private func setupStrings() {
        tabBarItem.title = L10n.empty
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}
