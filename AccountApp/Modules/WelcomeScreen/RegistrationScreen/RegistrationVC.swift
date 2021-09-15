import CoreData
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa
import KeychainSwift
import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let keychain = KeychainSwift()
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel: RegistrationViewModel!
    private let disposeBag = DisposeBag()
    private var alertWrongTitle = ""
    private var alertErrorTitle = ""
    private var alertErrorPasswordMessage = ""
    private var alertErrorEmptyFieldsMessage = ""
    private var alertRecommendationForFieldsMessage = ""
    private var alertDoneTitle = ""
    private var alertErrorLoginExistsMessage = ""
    
    // MARK: - IBActions
    
    @IBAction private func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        let image = passwordTextField.isSecureTextEntry ? UIImage(named: "iconEye") : UIImage(named: "iconClosedEye")
        showPasswordButton.setImage(image, for: .normal)
    }
    
    @IBAction private func changedPasswordTextField(_ sender: Any) {
        showPasswordButton.isHidden = passwordTextField.text?.isEmpty ?? true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForTextFields(loginTextField: loginTextField, passwordTextField: passwordTextField)
        ThemeManager.setupThemeForButtons(saveButton: saveButton)
    }
    
    public func configure(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Logic
    
    private func setupUI() {
        showPasswordButton.isHidden = true
        showPasswordButton.setImage(UIImage(named: "iconEye"), for: .normal)
        [loginTextField, passwordTextField].forEach {
            $0.textAlignment = .center
        }
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
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
        alertErrorLoginExistsMessage = L10n.alertErrorLoginExistsMessage
    }
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.registration
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

// MARK: - Binding

private extension RegistrationViewController {
    
    func bind() {
        let output = viewModel.bind(
            input: RegistrationInput(
                saveEvent: saveButton.rx.tap,
                loginText: loginTextField.rx.text.asDriver(),
                passwordText: passwordTextField.rx.text.asDriver()
            )
        )
        let registrationStateDisposable = output.registrationState.skip(1).drive(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .allIsGood(let user):
                self.setupStyleForTestFields(title: L10n.alertDoneTitle , titleColor: .green)
                self.keychain.set(user.password, forKey: user.login)
                self.dataBase.openDatabse(login: user.login)
                self.viewModel.steps.accept(RegistrationStep.completeStep)
            case .emptyFields:
                self.setupStyleForTestFields(title: self.alertErrorTitle, titleColor: .red)
                self.showAlert(title: self.alertErrorTitle, message: self.alertErrorEmptyFieldsMessage)
            case .invalidValidation:
                self.setupStyleForTestFields(title: self.alertWrongTitle, titleColor: .red)
                self.showAlert(title: self.alertErrorTitle, message: self.alertRecommendationForFieldsMessage)
            case .loginAlreadyExists:
                self.setupStyleForTestFields(title: self.alertWrongTitle, titleColor: .red)
                self.showAlert(title: self.alertErrorTitle, message: self.alertErrorLoginExistsMessage)
                }
            }
        )
        disposeBag.insert(registrationStateDisposable,
                          output.disposable)
    }
}
