import UIKit

public enum Xib: String {
    case CustomViewForEditCredentialsCell
    case LogOutViewCell
}

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
    // MARK: - IBActions
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        registerNib()
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
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .black
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.CustomViewForEditCredentialsCell.rawValue, for: indexPath) as? CustomViewForEditCredentialsCell else { return UITableViewCell() }
            cell.backgroundColor = .black
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Xib.LogOutViewCell.rawValue, for: indexPath) as? LogOutViewCell else { return UITableViewCell() }
            cell.backgroundColor = .black
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "ChangeProfileScreen", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "ChangeProfileViewController") as? ChangeProfileViewController else { return }
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
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
