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
        setupStrings()
        handleLanguage()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForSwitchAndTableView(themeSwitch: themeSwitch)
        ThemeManager.setupThemeForLabels(changeThemeLabel: changeThemeLabel)
    }
    
    public func configure(viewModel: SwitchThemeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    
    private func setupStrings() {
        changeThemeLabel.text = L10n.switchThemeVCLabel
        navigationController?.navigationBar.topItem?.title = L10n.switchThemeVCNavigationTitle
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

// MARK: - Binding

private extension SwitchThemeViewController {
    
    func bind() {
        guard let viewModel = self.viewModel else {
            print("\n LOG can’t get viewModel")
            return
        }
        let output = viewModel.bind(
            input: SwitchThemeInput(
                switchEvent: themeSwitch.rx.isOn.changed
            )
        )
        
        let switchDisposable = output.switchThemeState.subscribe { changedState in
            guard let value = changedState.element else {
                print("\n LOG can’t get element from ChangedState")
                return
            }
            Theme.currentTheme = value ? DarkTheme() : LightTheme()
            ThemeManager.setupThemeForNavigationAndView(navigation: self.navigationController!, view: self.view)
            ThemeManager.setupThemeForSwitchAndTableView(themeSwitch: self.themeSwitch)
            ThemeManager.setupThemeForLabels(changeThemeLabel: self.changeThemeLabel)
            self.themeSwitch.isOn = value
        }
        disposeBag.insert(switchDisposable, output.disposable)
    }
}
