import UIKit

class MainViewController: UITabBarController {

    private var sessionManager: SessionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        navigationController?.view.tintColor = Colors.gold
    }

    private func setupSession() {
        sessionManager = SessionManager(navigation: self.navigationController!)
        sessionManager!.startTimer()
        sessionManager!.saveStartOfSession()
        print(sessionManager!.getStartOfSession())
    }
}
