import CoreData
import UIKit

class FirstViewController: UIViewController {
    
    private let sessionManager = SessionManager()
    private let formatter = DateFormatter()
    private weak var timer: Timer?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var timerLabel: UILabel!
    
    // MARK: - Variables
    
    private let languageHandler = LanguageNotificationHandler()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStrings()
        handleLanguage()
        setupFormatter()
        setupTime()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeManager.setupThemeForNavigationAndView(navigation: navigationController!, view: view)
    }
    
    // MARK: - Setup
    
    private func setupFormatter() {
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "h:mm:ss a"
    }
    
    private func setupTime() {
        timerLabel.text = formatter.string(from: sessionManager.currentTime())
    }
    
    private func setupStrings() {
        navigationController?.navigationBar.topItem?.title = L10n.empty
    }
    
    private func handleLanguage() {
        languageHandler.startListening { [weak self] in
            self?.setupStrings()
        }
    }
    
    @objc func timerHandler(_ timer: Timer) {
        timerLabel.text = formatter.string(from: (sessionManager.currentTime()))
    }

}
