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
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var showNewPassowrdButton: UIButton!
    
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
        setupDelegate()
        setupUI()
        setupStrings()
        setupStringsForAlert()
        handleLanguage()
        bind()
        setupKeyboard()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataBase.fetchData()
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForTextFields(loginTextField: loginTextField, passwordTextField: passwordTextField, newLoginTextField: newLoginTextField, newPasswordTextField: newPasswordTextField)
        ThemeManager.setupThemeForButtons(saveButton: saveButton)
    }
    
    public func configure(viewModel: ChangeProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    
    private func setupBinding() {
        showPasswordButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
            let image = self.passwordTextField.isSecureTextEntry ? UIImage(named: "iconEye") : UIImage(named: "iconClosedEye")
            self.showPasswordButton.setImage(image, for: .normal)
        }).disposed(by: disposeBag)
        
        showNewPassowrdButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.newPasswordTextField.isSecureTextEntry = !self.newPasswordTextField.isSecureTextEntry
            let image = self.newPasswordTextField.isSecureTextEntry ? UIImage(named: "iconEye") : UIImage(named: "iconClosedEye")
            self.showNewPassowrdButton.setImage(image, for: .normal)
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.showPasswordButton.isHidden = self.passwordTextField.text?.isEmpty ?? true
        }).disposed(by: disposeBag)
        
        newPasswordTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.showNewPassowrdButton.isHidden = self.newPasswordTextField.text?.isEmpty ?? true
        }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        [loginTextField, passwordTextField, newLoginTextField, newPasswordTextField].forEach {
            $0.textAlignment = .center
        }
        [showPasswordButton, showNewPassowrdButton].forEach {
            $0?.isHidden = true
            $0?.setImage(UIImage(named: "iconEye"), for: .normal)
        }
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = Colors.gold.cgColor
    }
    
    private func setupStyleForTestFields(title: String, titleColor: UIColor) {
        [loginTextField, passwordTextField, newLoginTextField, newPasswordTextField].forEach {
            $0?.title = title
            $0?.titleColor = titleColor
        }
    }
    
    private func setupDelegate() {
        [loginTextField, passwordTextField, newLoginTextField, newPasswordTextField].forEach {
            $0.delegate = self
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
        loginTextField.placeholder = L10n.changeProfileVCLoginPlaceholder
        passwordTextField.placeholder = L10n.changeProfileVCPasswordPlaceholder
        newPasswordTextField.placeholder = L10n.changeProfileVCNewPasswordPlaceholder
        newLoginTextField.placeholder = L10n.changeProfileVCNewLoginPlaceholder
        saveButton.setTitle(L10n.save, for: .normal)
    }
    
    private func animateViewMoving(_ up: Bool, moveValue: CGFloat) {
        let movement: CGFloat = ( up ? -moveValue : moveValue)
        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }
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
    
    private func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension ChangeProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            animateViewMoving(true, moveValue: 100)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
            animateViewMoving(false, moveValue: 100)
    }
}

// MARK: - Binding

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
            guard let newLogin = self.newLoginTextField.text, let newPassword = self.newPasswordTextField.text else {
                print("\n LOG can’t get text from loginTextField and passwordTextField")
                return
            }
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
