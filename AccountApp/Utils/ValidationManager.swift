import RxCocoa
import RxSwift
import UIKit

final public class ValidationManager {
    static func isValidLogin(login: BehaviorRelay<String?>) -> Bool {
        guard let login = login.value, login.count >= 3 else {
            print("\n LOG can’t get login.value from BehaviorRelay")
            return false
        }
        return PredicateText.login.evaluate(with: login)
    }
    
    static func isValidPassword(password: BehaviorRelay<String?>) -> Bool {
        guard let password = password.value, password.count >= 8 else {
            print("\n LOG can’t get password.value from BehaviorRelay")
            return false
        }
        return PredicateText.password.evaluate(with: password)
    }
}
