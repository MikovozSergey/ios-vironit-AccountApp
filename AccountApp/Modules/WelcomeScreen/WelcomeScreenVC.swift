import CoreData
import KeychainSwift
import RxCocoa
import RxSwift
import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private var bag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLanguage()
        setupUI()
        
        logInButton.rx.tap.subscribe(onNext:  { [weak self] in
            let storyboard = UIStoryboard(name: "LogInScreen", bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: bag)
        registrationButton.rx.tap.subscribe(onNext:  { [weak self] in
            
            let storyboard = UIStoryboard(name: "RegistrationScreen", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return }
            self?.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: bag)
       // dispo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
    }
    
    // MARK: - IBActions
    
//    @IBAction private func pressedLogInButton(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "LogInScreen", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else { return }
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    @IBAction private func pressedRegistrationButton(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "RegistrationScreen", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return }
//        navigationController?.pushViewController(viewController, animated: true)
//    }
    
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
