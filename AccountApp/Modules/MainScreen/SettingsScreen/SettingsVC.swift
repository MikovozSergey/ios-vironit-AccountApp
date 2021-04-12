import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageSwitch: UISwitch!
    @IBOutlet private weak var changeLoginAndPassButton: UIButton!
    @IBOutlet private weak var logOutButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - IBActions
    
    @IBAction private func tappedOnSwitcher(_ sender: Any) {
        if languageSwitch.isOn == true {
            languageLabel.text = "Change language on Russian?"
        } else {
            languageLabel.text = "Изменить язык на английский?"
        }
    }
    
    @IBAction private func tappedChangeLoginAndPassButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChangeProfileScreen", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "ChangeProfileViewController") as? ChangeProfileViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func tappedLogOutButton(_ sender: Any) {
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    private func setupUI() {
        // language switch
        languageSwitch.subviews[0].subviews[0].backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        languageSwitch.onTintColor = Colors.gold
        
        // logOut button
        logOutButton.setTitle("Выйти", for: .normal)
        logOutButton.layer.borderWidth = 1.5
        logOutButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
    }
}
