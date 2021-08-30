import UIKit

extension UIViewController {
    
    func isValidLogin(login: String) -> Bool {
        guard login.count >= 3 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[А-Яа-яA-Za-z])(?=.*\\d)[А-Яа-яA-Za-z\\d]{3,}$")
        return predicateTest.evaluate(with: login)
    }
    
    func isValidPassword(password: String) -> Bool {
        guard password.count >= 8 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[а-яa-z])(?=.*[А-ЯA-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[А-Яа-яA-Za-z\\d$@$!%*?&#]{8,}$")
        return predicateTest.evaluate(with: password)
    }
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", comment: "")
    }
}
