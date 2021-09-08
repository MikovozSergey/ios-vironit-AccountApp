import RxCocoa
import RxSwift
import UIKit

class SwitchThemeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var themeSwitch: UISwitch!
    @IBOutlet private weak var changeThemeLabel: UILabel!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel: SwitchThemeViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleLanguage()
        setupTheme()
        bind()
    }
    
    // MARK: - Logic
    
    private func setupUI() {
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        setupStrings()
    }
    
    private func setupStrings() {
        changeThemeLabel.text = L10n.switchThemeVCLabel
    }
    
    private func setupTheme() {
        
        themeSwitch.tintColor = Theme.currentTheme.accentColor
        themeSwitch.onTintColor = Theme.currentTheme.accentColor
        self.navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        changeThemeLabel.textColor = Theme.currentTheme.textColor
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
    
    public func configure(viewModel: SwitchThemeViewModel) {
        self.viewModel = viewModel
    }
}

private extension SwitchThemeViewController {
    
    func bind() {
        guard let viewModel = self.viewModel else { return }
        let output = viewModel.bind(
            input: SwitchThemeInput(
                switchEvent: themeSwitch.rx.isOn.changed
            )
        )
        
        let switchDisposable = output.switchThemeState.subscribe { changedState in
            guard let value = changedState.element else { return }
            Theme.currentTheme = value ? DarkTheme() : LightTheme()
            self.setupTheme()
            self.themeSwitch.isOn = value
        }
        disposeBag.insert(switchDisposable, output.disposable)
    }
}
