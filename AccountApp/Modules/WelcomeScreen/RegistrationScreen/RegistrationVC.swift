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
    
    // MARK: - IBActions
    
    @IBAction private func tappedLoginTextField(_ sender: Any) {
        if loginTextField.text?.isEmpty != nil {
            loginTextField.title = "RegistrationVCLoginTitle".localized()
        }
    }
    
    @IBAction private func tappedPasswordTextField(_ sender: Any) {
        if passwordTextField.text?.isEmpty != nil {
            passwordTextField.title = "RegistrationVCPasswordTitle".localized()
        }
    }
  
    @IBAction private func tappedSaveButton(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        if !login.isEmpty && !password.isEmpty {
            if isValidLogin(login: login) && isValidPassword(password: password) {
                setupStyleForTestFields(title: "AlertDoneTitle".localized() , titleColor: .green)
                keychain.set(password, forKey: login)
                dataBase.openDatabse(login: login)
                let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
                guard let vc = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
                navigationController?.pushViewController(vc, animated: true)
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
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        setupUI()
    }
    
    // MARK: - Logic

    private func setupUI() {
        // navigation bar
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
        // login label
        loginTextField.textAlignment = .center
        loginTextField.placeholder = "RegistrationVCLoginPlaceholder".localized()
        
        // password label
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "RegistrationVCPasswordPlaceholder".localized()
        
        // save button
        saveButton.setTitle("Save".localized(), for: .normal)
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "AlertDoneTitle".localized(), style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    private func setupStyleForTestFields(title: String, titleColor: UIColor) {
        loginTextField.title = title
        loginTextField.titleColor = titleColor
        passwordTextField.title = title
        passwordTextField.titleColor = titleColor
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
