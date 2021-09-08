import CoreData
import UIKit

class ListOfAccountsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let languageHandler = LanguageNotificationHandler()
 //   private var filteredData: [String]!
 //   private var searchController: UISearchController!
    
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
        
 //       filteredData = dataBase.arrayOfLogins

//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        tableView.tableHeaderView = searchController.searchBar
//        definesPresentationContext = true
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
        tableView.tableFooterView = UIView()
    }
    
    private func setupStrings() {
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

//extension ListOfAccountsViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            filteredData = searchText.isEmpty ? dataBase.arrayOfLogins : dataBase.arrayOfLogins.filter({(dataString: String) -> Bool in
//                return dataString.range(of: searchText, options: .caseInsensitive) != nil
//            })
//            tableView.reloadData()
//        }
//    }
//}
