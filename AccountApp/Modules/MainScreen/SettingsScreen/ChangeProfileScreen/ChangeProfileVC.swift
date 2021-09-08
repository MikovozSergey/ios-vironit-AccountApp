import KeychainSwift
import RxCocoa
import RxSwift
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
    private var viewModel: ChangeProfileViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleLanguage()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataBase.fetchData()
        setupTheme()
    }
    
    public func configure(viewModel: ChangeProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Logic
    
    private func setupTheme() {
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        loginTextField.textColor = Theme.currentTheme.textColor
        newLoginTextField.textColor = Theme.currentTheme.textColor
        passwordTextField.textColor = Theme.currentTheme.textColor
        newPasswordTextField.textColor = Theme.currentTheme.textColor
        saveButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = false
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
        newLoginTextField.title = title
        newLoginTextField.titleColor = titleColor
        passwordTextField.title = title
        passwordTextField.titleColor = titleColor
        newPasswordTextField.title = title
        newPasswordTextField.titleColor = titleColor
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

private extension ChangeProfileViewController {
    
    func bind() {
        let output = viewModel.bind(
            input: ChangeProfileInput(
                saveEvent: saveButton.rx.tap,
                loginText: loginTextField.rx.text.asDriver(),
                newLoginText: newLoginTextField.rx.text.asDriver(),
                passwordText: passwordTextField.rx.text.asDriver(),
                newPasswordText: newPasswordTextField.rx.text.asDriver()
            )
        )
        let changeProfileStateDisposable = output.changeProfileState.skip(1).drive(onNext: { [weak self] state in
            guard let self = self else { return }
            guard let newLogin = self.newLoginTextField.text, let newPassword = self.newPasswordTextField.text else { return }
            switch state {
            case .allIsGood(let user):
                if self.dataBase.arrayOfLogins.contains(user.login) && user.password == self.keychain.get(user.login) {
                    self.setupStyleForTestFields(title: L10n.alertDoneTitle, titleColor: .green)
                    self.keychain.delete(user.login)
                    self.keychain.set(newPassword, forKey: newLogin)
                    self.dataBase.deleteObject(logIn: user.login)
                    self.dataBase.openDatabse(login: newLogin)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorPasswordMessage)
                }
            case .emptyFields:
                self.setupStyleForTestFields(title: L10n.alertErrorTitle, titleColor: .red)
                self.showAlert(title: L10n.alertErrorTitle, message: L10n.alertErrorEmptyFieldsMessage)
            case .invalidValidation:
                self.setupStyleForTestFields(title: L10n.alertWrongTitle, titleColor: .red)
                self.showAlert(title: L10n.alertErrorTitle, message: L10n.alertRecommendationForFieldsMessage)
            }
        })
        disposeBag.insert(changeProfileStateDisposable,
                          output.disposable)
    }
}
