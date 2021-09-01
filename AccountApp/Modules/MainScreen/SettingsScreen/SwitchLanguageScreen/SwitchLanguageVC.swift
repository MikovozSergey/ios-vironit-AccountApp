import UIKit

class SwitchLanguageViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var switchLanguageLabel: UILabel!
    @IBOutlet private weak var switchLanguageButton: UIButton!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - IBActions
    
    @IBAction private func tappedSwitchLanguageButton(_ sender: Any) {
        
        let language = UserDefaults.standard.string(forKey: kLanguageApplication)
        
        if language ==  Language.english.languageShort {
            UserDefaults.standard.set(Language.russian.languageShort, forKey: kLanguageApplication)
            L10n.bundle = Bundle(path: Bundle.main.path(forResource: "ru", ofType: "lproj")!)
        } else {
            UserDefaults.standard.set(Language.english.languageShort, forKey: kLanguageApplication)
            L10n.bundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: nil)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    // MARK: - Logic
    
    private func setupUI() {
        // navigation bar
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
        // switchLanguageButton
        setupStrings()
        switchLanguageButton.layer.borderWidth = 1.5
        switchLanguageButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func setupStrings() {
            switchLanguageLabel.text = L10n.switchLanguageVCTitle
            switchLanguageButton.setTitle(L10n.edit, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "AlertDoneTitle".localized(), style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
}
