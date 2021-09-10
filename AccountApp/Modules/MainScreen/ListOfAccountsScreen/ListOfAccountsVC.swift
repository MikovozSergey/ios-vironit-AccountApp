import CoreData
import UIKit

class ListOfAccountsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let languageHandler = LanguageNotificationHandler()
    private var filteredListOfAccounts: [String] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataBase.fetchData()
        filteredListOfAccounts = dataBase.arrayOfLogins
        setupTheme()
        tableView.reloadData()
        handleLanguage()
    }
    
    private func setupTheme() {
        searchBar.isTranslucent = true
        searchBar.barTintColor = Theme.currentTheme.backgroundColor
        searchBar.searchTextField.backgroundColor = .white
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        navigationController?.navigationBar.topItem?.title = L10n.list
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.list
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
}

// MARK: - Delegate / DataSource methods

extension ListOfAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredListOfAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = Colors.gold
        cell.contentView.backgroundColor = Theme.currentTheme.backgroundColor
        cell.textLabel?.text = filteredListOfAccounts[indexPath.row]
        return cell
    }
}

extension ListOfAccountsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        filteredListOfAccounts = searchText.isEmpty ? dataBase.arrayOfLogins : dataBase.arrayOfLogins.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
