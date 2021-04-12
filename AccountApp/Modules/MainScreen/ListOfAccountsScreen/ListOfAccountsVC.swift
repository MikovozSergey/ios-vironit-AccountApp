import CoreData
import UIKit

class ListOfAccountsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    let myArray = ["Prank", "Liker", "Mem"]
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - CoreData methods

}

// MARK: - Delegate / DataSource methods

extension ListOfAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = Colors.gold
        cell.textLabel?.text = myArray[indexPath.row]
        return cell
    }
    
}
