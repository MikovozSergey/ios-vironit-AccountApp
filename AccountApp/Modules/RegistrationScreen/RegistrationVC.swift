import CoreData
import SkyFloatingLabelTextField
import KeychainSwift
import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let keychain = KeychainSwift()
    private var context: NSManagedObjectContext!
    private lazy var regexForLogin = "^(?=.*[а-я])(?=.*[А-Я])(?=.*\\d)(?=.*[$@$!%*?&#])[А-Яа-я\\d$@$!%*?&#]{3,}$"
    private lazy var regexForPassword = "^(?=.*[а-я])(?=.*[А-Я])(?=.*\\d)(?=.*[$@$!%*?&#])[А-Яа-я\\d$@$!%*?&#]{8,}$"
    
    // MARK: - IBActions
    
    @IBAction private func tappedLoginTextField(_ sender: Any) {
        if loginTextField.text?.isEmpty != nil {
            loginTextField.title = "Ваш логин"
        }
    }
    
    @IBAction private func tappedPasswordTextField(_ sender: Any) {
        if passwordTextField.text?.isEmpty != nil {
            passwordTextField.title = "Ваш пароль"
        }
    }
    
    @IBAction private func tappedSaveButton(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        if !login.isEmpty && !password.isEmpty {
            if isValidLogin(login: login) && isValidPassword(password: password) {
                setupStyleForTestFields(title: "Ок" , titleColor: .green)
                keychain.set(password, forKey: "password")
                openDatabse()
                showAlert(title: "Поздравляем", message: "Регистрация прошла успешно!")
            } else {
                setupStyleForTestFields(title: "Неверно", titleColor: .red)
                showAlert(title: "Ошибка", message: "Неверный логин или пароль. \nЛогин должен содержать: минимум 3 символа, минимум 1 букву и 1 число. \nПароль должен содержать: минимум 8 символов, 1 большую букву, 1 маленькую букву, 1 цифру и 1 специальный символ")
            }
            
        } else {
            setupStyleForTestFields(title: "Ошибка", titleColor: .red)
            showAlert(title: "Ошибка", message: "Заполните поля для регистрации")
        }
        
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        setupUI()
    }
    
    // MARK: - Logic

    private func setupUI() {
        // navigation bar
        navigationController?.view.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        
        // login label
        loginTextField.textAlignment = .center
        loginTextField.placeholder = "Введите логин"
        
        // password label
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "Введите пароль"
        
        // save button
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = CGColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    private func setupStyleForTestFields(title: String, titleColor: UIColor) {
        loginTextField.title = title
        loginTextField.titleColor = titleColor
        passwordTextField.title = title
        passwordTextField.titleColor = titleColor
    }
    
    // MARK: - CoreData methods
    
    func openDatabse() {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(accountObj: newUser)
    }

    func saveData(accountObj: NSManagedObject) {
        accountObj.setValue(loginTextField.text, forKey: "login")

        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }

        fetchData()
    }

    func fetchData() {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                guard let login = data.value(forKey: "login") as? String else { return }
                print("User name is - \(login)")
            }
        } catch {
            print("Fetching data Failed")
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
