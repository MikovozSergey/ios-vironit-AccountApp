import CoreData
import RxSwift
import RxCocoa
import UIKit

class ListOfAccountsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    private let dataBase = DataBase()
    private let languageHandler = LanguageNotificationHandler()
    private var filteredListOfAccounts: [String] = []
    private let viewModel = ListOfAccountsViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
        setupStrings()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataBase.fetchData()
        filteredListOfAccounts = dataBase.arrayOfLogins
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
        ThemeManager.setupThemeForSwitchAndTableView(tableView: tableView)
        ThemeManager.setupThemeForSearchBar(searchBar: searchBar)
        handleLanguage()
        tableView.reloadData()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        guard let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton else { return }
        cancelButton.setTitle("Cancel", for: .normal)
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
    
    private func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource

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

// MARK: - UISearchBarDelegate

extension ListOfAccountsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            print("\n LOG can’t get text from searchBar")
            return
        }
        filteredListOfAccounts = searchText.isEmpty ? dataBase.arrayOfLogins : dataBase.arrayOfLogins.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredListOfAccounts =  dataBase.arrayOfLogins
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Binding

private extension ListOfAccountsViewController {
    func bind() {
        let output =  viewModel.bind()
        output.arrayOfLogins.subscribe { [weak self] array in
            guard let array = array.element else {
                print("\n LOG can’t get array.element")
                return }
            self?.filteredListOfAccounts = array
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
