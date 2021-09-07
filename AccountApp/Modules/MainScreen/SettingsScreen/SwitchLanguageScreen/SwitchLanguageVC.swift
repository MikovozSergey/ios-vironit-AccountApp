import RxCocoa
import RxSwift
import UIKit

class SwitchLanguageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var switchLanguageLabel: UILabel!
    @IBOutlet private weak var switchLanguageButton: UIButton!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel = SwitchLanguageViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - IBActions
    
//    @IBAction private func tappedSwitchLanguageButton(_ sender: Any) {
//        
//        let language = UserDefaults.standard.string(forKey: kLanguageApplication)
//        
//        if language ==  Language.english.languageShort {
//            UserDefaults.standard.set(Language.russian.languageShort, forKey: kLanguageApplication)
//            L10n.bundle = Bundle(path: Bundle.main.path(forResource: "ru", ofType: "lproj")!)
//        } else {
//            UserDefaults.standard.set(Language.english.languageShort, forKey: kLanguageApplication)
//            L10n.bundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
//        }
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: nil)
//        }
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleLanguage()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTheme()
    }
    
    // MARK: - Logic
    
    private func setupTheme() {
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        switchLanguageLabel.textColor = Theme.currentTheme.textColor
        switchLanguageButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }
    
    private func setupUI() {
        self.navigationController!.navigationBar.topItem!.title = ""
        setupStrings()
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        switchLanguageButton.layer.borderWidth = 1.5
        switchLanguageButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func setupStrings() {
        switchLanguageLabel.text = L10n.switchLanguageVCTitle
        switchLanguageButton.setTitle(L10n.edit, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

private extension SwitchLanguageViewController {
    
    func bind() {
        let output = viewModel.bind(
            input: SwitchLanguageInput(
                switchEvent: switchLanguageButton.rx.tap
            )
        )
        let switchStateDisposable = output.switchState.skip(1).drive(onNext: { [weak self] state in
            switch state {
            case .allIsGood:
                let language = UserDefaults.standard.string(forKey: kLanguageApplication)
                
                if language ==  Language.english.languageShort {
                    UserDefaults.standard.set(Language.russian.languageShort, forKey: kLanguageApplication)
                    L10n.bundle = Bundle(path: Bundle.main.path(forResource: "ru", ofType: "lproj")!)
                } else {
                    UserDefaults.standard.set(Language.english.languageShort, forKey: kLanguageApplication)
                    L10n.bundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
                }
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name.changeLanguage, object: nil)
                }
            }
        }
        )
        disposeBag.insert(switchStateDisposable,
                          output.disposable)
    }
}
