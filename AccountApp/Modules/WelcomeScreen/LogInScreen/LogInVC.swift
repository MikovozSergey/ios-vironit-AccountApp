import CoreData
import SkyFloatingLabelTextField
import KeychainSwift
import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var logInButton: UIButton!
    
    // MARK: - Variables

    private let keychain = KeychainSwift()
    private let dataBase = DataBase()
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - IBActions

    @IBAction private func tappedLoginTextField(_ sender: Any) {
        if loginTextField.text?.isEmpty != nil {
          setupFieldsTitle(isLogin: true)
        }
    }
    @IBAction private func tappedPasswordTextField(_ sender: Any) {
        if passwordTextField.text?.isEmpty != nil {
            setupFieldsTitle(isLogin: false)
        }
    }
    @IBAction private func tappedLogInButton(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        if dataBase.arrayOfLogins.contains(login) && password == keychain.get(login) {
            let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorPasswordMessage)
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataBase.fetchData()
        setupTheme()
    }
    
    // MARK: - Logic
    
    private func setupTheme() {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        loginTextField.textColor = Theme.currentTheme.textColor
        passwordTextField.textColor = Theme.currentTheme.textColor
        logInButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }

    private func setupUI() {
        setupStrings()
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        loginTextField.textAlignment = .center
        passwordTextField.textAlignment = .center
        logInButton.layer.borderWidth = 1.5
        logInButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func setupDelegate() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        loginTextField.text = "TestUser3"
        passwordTextField.text = "Qwerty1234!"
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: L10n.alertDoneTitle, style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    private func setupStyleForTestFields(title: String, titleColor: UIColor) {
        loginTextField.title = title
        loginTextField.titleColor = titleColor
        passwordTextField.title = title
        passwordTextField.titleColor = titleColor
    }
    
    private func setupFieldsTitle(isLogin: Bool) {
        if isLogin {
            loginTextField.title = L10n.logInVCLoginTitle
        } else {
            passwordTextField.title = L10n.logInVCPasswordTitle
        }
    }
    
    private func setupStrings() {
        loginTextField.placeholder = L10n.logInVCLoginPlaceholder
        passwordTextField.placeholder = L10n.logInVCPasswordPlaceholder
        logInButton.setTitle(L10n.enter, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
