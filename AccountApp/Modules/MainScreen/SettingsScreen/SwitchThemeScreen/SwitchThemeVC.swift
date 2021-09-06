import UIKit

class SwitchThemeViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var themeSwitch: UISwitch!
    @IBOutlet private weak var changeThemeLabel: UILabel!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - IBActions
    
    @IBAction private func switchTheme(_ sender: UISwitch) {
        Theme.currentTheme = themeSwitch.isOn ? DarkTheme() : LightTheme()
        setupTheme()
        UserDefaults.standard.set(sender.isOn, forKey: "DarkTheme")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleLanguage()
        setupTheme()
        themeSwitch.isOn = UserDefaults.standard.bool(forKey: "DarkTheme")
    }

    // MARK: - Logic
    
    private func setupUI() {
        self.navigationController!.navigationBar.topItem!.title = ""
        setupStrings()
    }
    
    private func setupStrings() {
        changeThemeLabel.text = L10n.switchThemeVCLabel
    }
    
    private func setupTheme() {
        themeSwitch.tintColor = Theme.currentTheme.accentColor
        themeSwitch.onTintColor = Theme.currentTheme.accentColor
        self.navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        changeThemeLabel.textColor = Theme.currentTheme.textColor
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}
