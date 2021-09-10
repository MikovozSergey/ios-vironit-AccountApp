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
    private var alertWrongTitle = ""
    private var alertErrorTitle = ""
    private var alertErrorPasswordMessage = ""
    private var alertErrorEmptyFieldsMessage = ""
    private var alertRecommendationForFieldsMessage = ""
    private var alertDoneTitle = ""
    
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
        navigationController?.view.tintColor = Colors.gold
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        view.backgroundColor = Theme.currentTheme.backgroundColor
        loginTextField.textColor = Theme.currentTheme.textColor
        newLoginTextField.textColor = Theme.currentTheme.textColor
        passwordTextField.textColor = Theme.currentTheme.textColor
        newPasswordTextField.textColor = Theme.currentTheme.textColor
        saveButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
        
    }
    
    private func setupUI() {
        setupStrings()
        setupStringsForAlert()
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
    
    private func setupStringsForAlert() {
        alertWrongTitle = L10n.alertWrongTitle
        alertErrorTitle = L10n.alertErrorTitle
        alertErrorPasswordMessage = L10n.alertErrorPasswordMessage
        alertErrorEmptyFieldsMessage = L10n.alertErrorEmptyFieldsMessage
        alertRecommendationForFieldsMessage = L10n.alertRecommendationForFieldsMessage
        alertDoneTitle = L10n.alertDoneTitle
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
            self?.setupStringsForAlert()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: self.alertDoneTitle, style: .default, handler: nil)
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
                    self.viewModel.steps.accept(ChangeProfileStep.backStep)
                } else {
                    self.setupStyleForTestFields(title: self.alertWrongTitle, titleColor: .red)
                    self.showAlert(title: self.alertErrorTitle, message: self.alertErrorPasswordMessage)
                }
            case .emptyFields:
                self.setupStyleForTestFields(title: self.alertErrorTitle, titleColor: .red)
                self.showAlert(title: L10n.alertErrorTitle, message: self.alertErrorEmptyFieldsMessage)
            case .invalidValidation:
                self.setupStyleForTestFields(title: self.alertWrongTitle, titleColor: .red)
                self.showAlert(title: self.alertErrorTitle, message: self.alertRecommendationForFieldsMessage)
            }
        })
        disposeBag.insert(changeProfileStateDisposable,
                          output.disposable)
    }
}
