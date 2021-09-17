import RxCocoa
import RxSwift
import UIKit

class SwitchLanguageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var switchLanguageLabel: UILabel!
    @IBOutlet private weak var switchLanguageButton: UIButton!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private var viewModel: SwitchLanguageViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStrings()
        handleLanguage()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForButtons(switchLanguageButton: switchLanguageButton)
        ThemeManager.setupThemeForLabels(switchLanguageLabel: switchLanguageLabel)
    }
    
    public func configure(viewModel: SwitchLanguageViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        switchLanguageButton.layer.borderWidth = 1.5
        switchLanguageButton.layer.borderColor = Colors.gold.cgColor
    }
    
    private func setupStrings() {
        switchLanguageLabel.text = L10n.switchLanguageVCLabel
        switchLanguageButton.setTitle(L10n.change, for: .normal)
        navigationController?.navigationBar.topItem?.title = L10n.changeLanguageVCNavigationTitle
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

// MARK: - Binding

private extension SwitchLanguageViewController {
    
    func bind() {
        guard let viewModel = self.viewModel else {
            print("\n LOG can’t get viewModel")
            return
        }
        let output = viewModel.bind(
            input: SwitchLanguageInput(
                switchEvent: switchLanguageButton.rx.tap
            )
        )
        disposeBag.insert(output.disposable)
    }
}
