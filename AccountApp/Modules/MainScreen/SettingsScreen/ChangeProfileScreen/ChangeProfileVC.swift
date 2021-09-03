import KeychainSwift
import SkyFloatingLabelTextField
import UIKit

class ChangeProfileViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var newLoginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var newPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let keychain = KeychainSwift()
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - IBActions
    
    @IBAction private func tappedSaveButton(_ sender: Any) {
        guard let oldLogin = loginTextField.text,
              let oldPassword = passwordTextField.text,
              let newLogin = newLoginTextField.text,
              let newPassword = newPasswordTextField.text else { return }
        if !oldLogin.isEmpty &&
           !oldPassword.isEmpty &&
           !newLogin.isEmpty &&
           !newPassword.isEmpty {
            if isValidLogin(login: oldLogin) &&
                isValidPassword(password: oldPassword) &&
                isValidLogin(login: newLogin) &&
                isValidPassword(password: newPassword) {
                if dataBase.arrayOfLogins.contains(oldLogin) && oldPassword == keychain.get(oldLogin) {
                    setupStyleForTestFields(title: L10n.alertDoneTitle, titleColor: .green)
                    keychain.delete(oldLogin)
                    keychain.set(newPassword, forKey: newLogin)
                    dataBase.deleteObject(logIn: oldLogin)
                    dataBase.openDatabse(login: newLogin)
                    navigationController?.popToRootViewController(animated: true)
                } else {
                    showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorPasswordMessage)
                }
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
        setupUI()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataBase.fetchData()
    }

    // MARK: - Logic
    
    private func setupUI() {
        setupStrings()
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        loginTextField.textAlignment = .center
        passwordTextField.textAlignment = .center
        newLoginTextField.textAlignment = .center
        newPasswordTextField.textAlignment = .center
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func setupStyleForTestFields(title: String, titleColor: UIColor) {
        loginTextField.title = title
        loginTextField.titleColor = titleColor
        passwordTextField.title = title
        passwordTextField.titleColor = titleColor
    }
    
    private func setupDelegate() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        newLoginTextField.delegate = self
        newPasswordTextField.delegate = self
    }
    
    private func setupStrings() {
        loginTextField.placeholder = L10n.changeProfileVCLoginPlaceholder
        passwordTextField.placeholder = L10n.changeProfileVCPasswordPlaceholder
        newPasswordTextField.placeholder = L10n.changeProfileVCNewPasswordPlaceholder
        newLoginTextField.placeholder = L10n.changeProfileVCNewLoginPlaceholder
        saveButton.setTitle(L10n.save, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: L10n.alertDoneTitle, style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
}

extension ChangeProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
