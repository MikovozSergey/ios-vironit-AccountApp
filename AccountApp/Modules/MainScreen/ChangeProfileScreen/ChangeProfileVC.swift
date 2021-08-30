import CoreData
import SkyFloatingLabelTextField
import UIKit

class ChangeProfileViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - IBActions
    
    @IBAction private func tappedSaveButton(_ sender: Any) {
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Logic
    
    private func setupUI() {
        // navigation bar
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
        // login textfield
        loginTextField.textAlignment = .center
        loginTextField.placeholder = "Введите новый логин"
        
        // password textfield
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "Введите новый пароль"
        
        // save button
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
}
