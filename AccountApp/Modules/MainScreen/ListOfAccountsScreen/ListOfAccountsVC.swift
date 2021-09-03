import CoreData
import UIKit

class ListOfAccountsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStrings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataBase.fetchData()
        setupDelegate()
        setupUI()
        handleLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
        tableView.reloadData()
    }
    
    private func setupTheme() {
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        setupStrings()
        tableView.tableFooterView = UIView()
    }
    
    private func setupStrings() {
        tabBarItem.title = L10n.list
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
        return dataBase.arrayOfLogins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = Colors.gold
        cell.contentView.backgroundColor = Theme.currentTheme.backgroundColor
        cell.textLabel?.text = dataBase.arrayOfLogins[indexPath.row]
        return cell
    }
}
