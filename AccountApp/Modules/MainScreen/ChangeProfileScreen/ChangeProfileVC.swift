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
                    setupStyleForTestFields(title: "AlertDoneTitle".localized() , titleColor: .green)
                    keychain.delete(oldLogin)
                    keychain.set(newPassword, forKey: newLogin)
                    dataBase.deleteObject(logIn: oldLogin)
                    dataBase.openDatabse(login: newLogin)
                    navigationController?.popToRootViewController(animated: true)
                } else {
                    showAlert(title: "AlertErrorTitle".localized(), message: "AlertErrorPasswordMessage".localized())
                }
            } else {
                setupStyleForTestFields(title: "AlertWrongTitle".localized(), titleColor: .red)
                showAlert(title: "AlertErrorTitle".localized(), message: "AlertRecommendationForFieldsMessage".localized())
            }
        } else {
            setupStyleForTestFields(title: "AlertErrorTitle".localized(), titleColor: .red)
            showAlert(title: "AlertErrorTitle".localized(), message: "AlertErrorEmptyFieldsMessage".localized())
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataBase.fetchData()
    }

    // MARK: - Logic
    
    private func setupUI() {
        // navigation bar
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
        // logins textfield
        loginTextField.textAlignment = .center
        loginTextField.placeholder = "ChangeProfileVCLoginPlaceholder".localized()
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "ChangeProfileVCPasswordPlaceholder".localized()
        
        // passwords textfield
        newLoginTextField.textAlignment = .center
        newLoginTextField.placeholder = "ChangeProfileVCNewLoginPlaceholder".localized()
        newPasswordTextField.textAlignment = .center
        newPasswordTextField.placeholder = "ChangeProfileVCNewPasswordPlaceholder".localized()
        
        // save button
        saveButton.setTitle("Save".localized(), for: .normal)
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "AlertDoneTitle".localized(), style: .default, handler: nil)
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
