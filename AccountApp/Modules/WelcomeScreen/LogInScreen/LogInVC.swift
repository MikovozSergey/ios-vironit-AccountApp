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
    
    // MARK: - IBActions

    @IBAction private func tappedLoginTextField(_ sender: Any) {
        if loginTextField.text?.isEmpty != nil {
          //  loginTextField.title = L10n.
        }
    }
    @IBAction private func tappedPasswordTextField(_ sender: Any) {
        if passwordTextField.text?.isEmpty != nil {
            passwordTextField.title = "LogInVCPasswordTitle".localized()
        }
    }
    @IBAction private func tappedLogInButton(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        if dataBase.arrayOfLogins.contains(login) && password == keychain.get(login) {
            let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            showAlert(title: "AlertErrorTitle".localized(), message: "AlertErrorPasswordMessage".localized())
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        loginTextField.text = "TestUser3"
        passwordTextField.text = "Qwerty1234!"
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
        
        // login label
        loginTextField.textAlignment = .center
        loginTextField.placeholder = "LogInVCLoginPlaceholder".localized()
        
        // password label
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "LogInVCPasswordPlaceholder".localized()
        
        // save button
        logInButton.setTitle("Enter".localized(), for: .normal)
        logInButton.layer.borderWidth = 1.5
        logInButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
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

extension LogInViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
