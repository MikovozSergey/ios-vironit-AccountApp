import SkyFloatingLabelTextField
import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginLabel: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordLabel: SkyFloatingLabelTextField!
    
    // MARK: - IBActions
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = ""
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)

    }
    
    // MARK: - Setup

    private func setupUI() {

    }
}
