import Foundation

final class NotificationHandler {
    
    typealias Handler = (Notification) -> Void
    private var tokens: [NSObjectProtocol] = []
    
    let names: [Notification.Name]
    
    init(_ names: [Notification.Name]) {
        self.names = names
    }
    
    deinit {
        stopListening()
    }
    
    func startListening(with handler: @escaping Handler) {
        stopListening()
        
        let nc = NotificationCenter.default
        tokens = names.map { nc.addObserver(forName: $0, object: nil, queue: OperationQueue.main, using: { handler($0) }) }
    }
    
    func stopListening() {
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
        tokens.removeAll()
    }
}

extension NotificationHandler {
    convenience init(_ name: Notification.Name) {
        self.init([name])
    }
}
