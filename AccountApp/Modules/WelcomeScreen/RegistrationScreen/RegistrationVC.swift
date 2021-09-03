import CoreData
import SkyFloatingLabelTextField
import KeychainSwift
import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let keychain = KeychainSwift()
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
  
    @IBAction private func tappedSaveButton(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        if !login.isEmpty && !password.isEmpty {
            if isValidLogin(login: login) && isValidPassword(password: password) {
                setupStyleForTestFields(title: L10n.alertDoneTitle , titleColor: .green)
                keychain.set(password, forKey: login)
                dataBase.openDatabse(login: login)
                let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
                guard let vc = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
                navigationController?.pushViewController(vc, animated: true)
            } else {
                setupStyleForTestFields(title: L10n.alertWrongTitle, titleColor: .red)
                showAlert(title: L10n.alertErrorTitle, message: L10n.alertRecommendationForFieldsMessage)
            }
        } else {
            setupStyleForTestFields(title: L10n.alertErrorTitle, titleColor: .red)
            showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorEmptyFieldsMessage)
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
        super.viewWillAppear(animated)
        setupTheme()
    }
    
    // MARK: - Logic

    private func setupTheme() {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        loginTextField.textColor = Theme.currentTheme.textColor
        passwordTextField.textColor = Theme.currentTheme.textColor
        saveButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }
    
    private func setupUI() {
        setupStrings()
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        loginTextField.textAlignment = .center
        passwordTextField.textAlignment = .center
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func setupDelegate() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
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
            loginTextField.title = L10n.registrationVCLoginTitle
        } else {
            passwordTextField.title = L10n.registrationVCPasswordTitle
        }
    }
    
    private func setupStrings() {
        loginTextField.placeholder = L10n.registrationVCLoginPlaceholder
        passwordTextField.placeholder = L10n.registrationVCPasswordPlaceholder
        saveButton.setTitle(L10n.save, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
