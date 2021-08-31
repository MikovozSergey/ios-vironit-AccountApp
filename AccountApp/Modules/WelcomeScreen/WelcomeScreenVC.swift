import CoreData
import KeychainSwift
import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBActions
    
    @IBAction private func pressedLogInButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LogInScreen", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "LogInViewController") as? LogInViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func pressedRegistrationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RegistrationScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        // logIn button
        logInButton.setTitle("Enter".localized(), for: .normal)
        logInButton.layer.borderWidth = 1.5
        logInButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
        // registration button
        registrationButton.setTitle("WelcomeVCSignUpButton".localized(), for: .normal)
    }
}
