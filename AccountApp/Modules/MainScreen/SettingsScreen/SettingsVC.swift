import RxCocoa
import RxSwift
import UIKit

public enum Xib: String {
    case CustomViewForEditCredentialsCell
    case LogOutViewCell
}

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var changeLanguageButton: UIButton!
    @IBOutlet private weak var changeThemeButton: UIButton!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    private let disposeBag = DisposeBag()
    private var viewModel: SettingsViewModel!
    private let sessionManager = SessionManager()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStrings()
        registerNib()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForSwitchAndTableView(tableView: tableView)
        ThemeManager.setupThemeForButtons(changeLanguageButton: changeLanguageButton, changeThemeButton: changeThemeButton)
        handleLanguage()
        tableView.reloadData()
    }
    
    public func configure(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    
    private func registerNib() {
        tableView.register(xib: Xib.CustomViewForEditCredentialsCell)
        tableView.register(xib: Xib.LogOutViewCell)
    }
    
    private func setupUI() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView()
        [changeLanguageButton, changeThemeButton].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1.5
            $0?.layer.borderColor = Colors.gold.cgColor
        }
    }
    
    private func setupStrings() {
        changeLanguageButton.setTitle(L10n.switchLanguageVCTitle, for: .normal)
        changeThemeButton.setTitle(L10n.switchThemeVCTitle, for: .normal)
        navigationController?.navigationBar.topItem?.title = L10n.settings
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.CustomViewForEditCredentialsCell.rawValue, for: indexPath) as? CustomViewForEditCredentialsCell else { return UITableViewCell() }
            let output = cell.bind()
            output.mainEvent.subscribe { [weak viewModel] _ in
                viewModel?.steps.accept(SettingsStep.changeUserNameAndPasswordStep)
            }.disposed(by: disposeBag)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.LogOutViewCell.rawValue, for: indexPath) as? LogOutViewCell else { return UITableViewCell() }
            let output = cell.bind()
            output.mainEvent.subscribe { [weak viewModel] _ in
                self.sessionManager.stopTimer()
                viewModel?.steps.accept(SettingsStep.logoutStep)
            }.disposed(by: disposeBag)
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}

// MARK: - Binding

private extension SettingsViewController {
    
    func bind() {
        let output = viewModel.bind(
            input: SettingsInput(
                changeLanguage: changeLanguageButton.rx.tap,
                changeTheme: changeThemeButton.rx.tap
            )
        )
        disposeBag.insert(output.disposable)
    }
}
