import Foundation

extension Notification.Name {
    static let changeLanguage = Notification.Name("scalpel.changeLanguade")
}

extension NotificationHandler {
    convenience init(_ name: Notification.Name) {
        self.init([name])
    }
}
