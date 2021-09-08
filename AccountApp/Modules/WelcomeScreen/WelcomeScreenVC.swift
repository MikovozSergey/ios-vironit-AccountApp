import CoreData
import KeychainSwift
import RxCocoa
import RxSwift
import RxFlow
import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private var disposeBag = DisposeBag()
    private var viewModel: WelcomeViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLanguage()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
    }
    
    public func configure(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    
    private func setupTheme() {
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        logInButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
        registrationButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }
    
    private func setupUI() {
        setupStrings()
        logInButton.layer.borderWidth = 1.5
        logInButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func setupStrings() {
        logInButton.setTitle(L10n.enter, for: .normal)
        registrationButton.setTitle(L10n.welcomeVCSignUpButton, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

private extension WelcomeViewController {
    
    func bind() {
        let output = viewModel.bind(
            input: WelcomeInput(
                loginEvent: logInButton.rx.tap,
                registrationEvent: registrationButton.rx.tap
            )
        )
        disposeBag.insert(output.disposable)
    }
}
