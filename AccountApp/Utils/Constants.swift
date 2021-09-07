import UIKit

struct Colors {
    static let gold = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
}

struct PredicateText {
    static let login = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[А-Яа-яA-Za-z])(?=.*\\d)[А-Яа-яA-Za-z\\d]{3,}$")
    static let password = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[а-яa-z])(?=.*[А-ЯA-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[А-Яа-яA-Za-z\\d$@$!%*?&#]{8,}$")
}
