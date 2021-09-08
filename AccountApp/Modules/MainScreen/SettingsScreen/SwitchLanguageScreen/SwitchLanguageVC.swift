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
        handleLanguage()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTheme()
    }
    
    public func configure(viewModel: SwitchLanguageViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Logic
    
    private func setupTheme() {
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        switchLanguageLabel.textColor = Theme.currentTheme.textColor
        switchLanguageButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }
    
    private func setupUI() {
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
        guard let viewModel = self.viewModel else { return }
        let output = viewModel.bind(
            input: SwitchLanguageInput(
                switchEvent: switchLanguageButton.rx.tap
            )
        )
        disposeBag.insert(output.disposable)
    }
}
