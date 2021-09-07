import Foundation

final class LanguageNotificationHandler {
    
    private let notificationHandler = NotificationHandler(.changeLanguage)
    
    typealias Handler = () -> Void
    
    deinit {
        stopListening()
    }
    
    func startListening(with handler: @escaping Handler) {
        stopListening()
        notificationHandler.startListening(with: { _ in handler() })
    }
    
    func stopListening() {
        notificationHandler.stopListening()
    }
}
