import CoreData
import RxCocoa
import RxSwift
import SkyFloatingLabelTextField
import KeychainSwift
import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!

    // MARK: - Variables

    private let keychain = KeychainSwift()
    private let dataBase = DataBase()
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    private var alertWrongTitle = ""
    private var alertErrorTitle = ""
    private var alertErrorPasswordMessage = ""
    private var alertErrorEmptyFieldsMessage = ""
    private var alertRecommendationForFieldsMessage = ""
    private var alertDoneTitle = ""
    
    // MARK: - IBActions

    @IBAction private func changedPasswordTextField(_ sender: Any) {
        showPasswordButton.isHidden = passwordTextField.text?.isEmpty ?? true
    }
    
    @IBAction private func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        let image = passwordTextField.isSecureTextEntry ? UIImage(named: "iconEye") : UIImage(named: "iconClosedEye")
        showPasswordButton.setImage(image, for: .normal)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        setupStrings()
        setupStringsForAlert()
        handleLanguage()
        bind()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataBase.fetchData()
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForTextFields(loginTextField: loginTextField, passwordTextField: passwordTextField)
        ThemeManager.setupThemeForButtons(logInButton: logInButton)
    }
    
    public func configure(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Logic

    private func setupUI() {
        [loginTextField, passwordTextField].forEach {
            $0.textAlignment = .center
        }
        showPasswordButton.isHidden = true
        showPasswordButton.setImage(UIImage(named: "iconEye"), for: .normal)
        logInButton.layer.borderWidth = 1.5
        logInButton.layer.borderColor = Colors.gold.cgColor
    }
    
    private func setupDelegate() {
        [loginTextField, passwordTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: self.alertDoneTitle, style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    private func setupStyleForTestFields(title: String, titleColor: UIColor) {
        [loginTextField, passwordTextField].forEach {
            $0?.title = title
            $0?.titleColor = titleColor
        }
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
        navigationController?.navigationBar.topItem?.title = L10n.login
        loginTextField.placeholder = L10n.logInVCLoginPlaceholder
        passwordTextField.placeholder = L10n.logInVCPasswordPlaceholder
        logInButton.setTitle(L10n.enter, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
    
    private func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
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

// MARK: - Binding

private extension LogInViewController {
    
    func bind() {
        let output = viewModel.bind(
            input: LoginInput(
                logInEvent: logInButton.rx.tap,
                loginText: loginTextField.rx.text.asDriver(),
                passwordText: passwordTextField.rx.text.asDriver()
            )
        )
        let loginStateDisposable = output.loginState.skip(1).drive(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .allIsGood(let user):
                if self.dataBase.arrayOfLogins.contains(user.login) && user.password == self.keychain.get(user.login) {
                    self.viewModel.steps.accept(LoginStep.completeStep)
                } else {
                    self.setupStyleForTestFields(title: self.alertWrongTitle, titleColor: .red)
                    self.showAlert(title: self.alertErrorTitle, message: self.alertErrorPasswordMessage)
                }
            case .emptyFields:
                self.setupStyleForTestFields(title: self.alertErrorTitle, titleColor: .red)
                self.showAlert(title: self.alertErrorTitle, message: self.alertErrorEmptyFieldsMessage)
            case .invalidValidation:
                self.setupStyleForTestFields(title: self.alertWrongTitle, titleColor: .red)
                self.showAlert(title: self.alertErrorTitle, message: self.alertRecommendationForFieldsMessage)
                }
            }
        )
        disposeBag.insert(loginStateDisposable,
                          output.disposable)
    }
}
