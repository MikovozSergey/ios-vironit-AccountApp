import RxCocoa
import RxSwift
import UIKit

class SwitchThemeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var themeSwitch: UISwitch!
    @IBOutlet private weak var changeThemeLabel: UILabel!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel = SwitchThemeViewModel()
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
        self.navigationController!.navigationBar.topItem!.title = ""
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
}

private extension SwitchThemeViewController {
    
    func bind() {
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
