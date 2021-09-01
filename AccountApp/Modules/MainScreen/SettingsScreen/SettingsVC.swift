import UIKit

public enum Xib: String {
    case CustomViewForEditCredentialsCell
    case LogOutViewCell
}

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var changeLanguageButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction private func tappedChangeLanguageButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SwitchLanguageScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "SwitchLanguageViewController") as? SwitchLanguageViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        registerNib()
        handleLanguage()
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
        // tableView
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .black
        
        // changeLanguageButton
        setupStrings()
    }
    
    private func setupStrings() {
        changeLanguageButton.setTitle(L10n.switchLanguageVCTitle, for: .normal)
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.CustomViewForEditCredentialsCell.rawValue, for: indexPath) as? CustomViewForEditCredentialsCell else { return UITableViewCell() }
            guard let navigator = self.navigationController else { return UITableViewCell() }
            cell.backgroundColor = .black
            cell.configureNavigation(navigator: navigator)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.LogOutViewCell.rawValue, for: indexPath) as? LogOutViewCell else { return UITableViewCell() }
            guard let navigator = self.navigationController else { return UITableViewCell() }
            cell.backgroundColor = .black
            cell.configureNavigation(navigator: navigator)
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

extension UITableView {
    func register(xib: Xib) {
        self.register(xib.nib(), forCellReuseIdentifier: xib.rawValue)
    }
}

extension Xib {
    func nib() -> UINib {
        return UINib(nibName: self.rawValue, bundle: Bundle.main)
    }
    
    func firstView() -> UIView {
        return nib().instantiate(withOwner: nil, options: nil).first as! UIView
    }
}
