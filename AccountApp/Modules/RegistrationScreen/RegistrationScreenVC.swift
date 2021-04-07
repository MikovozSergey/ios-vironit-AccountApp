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
        navigationController?.view.tintColor = UIColor.white

    }
    
    // MARK: - Setup

    private func setupUI() {

    }
}
