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
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTabBarTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        registerNib()
        handleLanguage()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
        tableView.reloadData()
    }
    
    // MARK: - Setup
    
    private func setupBinding() {
        changeLanguageButton.rx.tap.subscribe(onNext:  { [weak self] in
            let storyboard = UIStoryboard(name: "SwitchLanguageScreen", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "SwitchLanguageViewController") as? SwitchLanguageViewController else { return }
            self?.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
        
        changeThemeButton.rx.tap.subscribe(onNext:  { [weak self] in
            let storyboard = UIStoryboard(name: "SwitchThemeScreen", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "SwitchThemeViewController") as? SwitchThemeViewController else { return }
            self?.navigationController?.pushViewController(viewController, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerNib() {
        tableView.register(xib: Xib.CustomViewForEditCredentialsCell)
        tableView.register(xib: Xib.LogOutViewCell)
    }
    
    private func setupUI() {
        setupStrings()
        tableView.tableFooterView = UIView()
    }
    
    private func setupTheme() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        changeLanguageButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
        changeThemeButton.setTitleColor(Theme.currentTheme.textColor, for: .normal)
    }
    
    private func setupStrings() {
        changeLanguageButton.setTitle(L10n.switchLanguageVCTitle, for: .normal)
        changeThemeButton.setTitle(L10n.switchThemeVCTitle, for: .normal)
    }
    
    private func setupTabBarTitle() {
        tabBarItem.title = L10n.settings
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
            self?.setupTabBarTitle()
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.CustomViewForEditCredentialsCell.rawValue, for: indexPath) as? CustomViewForEditCredentialsCell else { return UITableViewCell() }
            guard let navigator = self.navigationController else { return UITableViewCell() }
            cell.configure(navigator: navigator)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.LogOutViewCell.rawValue, for: indexPath) as? LogOutViewCell else { return UITableViewCell() }
            guard let navigator = self.navigationController else { return UITableViewCell() }
            cell.configure(navigator: navigator)
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
