import UIKit

final public class SessionManager {
 
    weak var timer: Timer?
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    private func currentTime() -> Date {
        let date = Date()
        _ = date.timeIntervalSince1970
        return date
    }
    
    private func saveStartOfSession() {
        let defaults = UserDefaults.standard
        defaults.set(currentTime(), forKey: "timeOfStartSession")
    }
    
    func getStartOfSession() -> Date {
        guard let date = UserDefaults.standard.object(forKey: "timeOfStartSession") as? Date else { return Date() }
        return date
    }
    
    func isEndOfSession(startOfSession: Date) -> Bool {
        let finishDate = startOfSession.addingTimeInterval(240.0 * 60.0)
        let currentTime = currentTime()
        print("Start: \(currentTime) \nFinish: \(finishDate)")
        if finishDate > currentTime { return false } else { return true }
    }

    @objc func timerHandler(_ timer: Timer) {
        if isEndOfSession(startOfSession: getStartOfSession()) {
            stopTimer()
            navigation.popToRootViewController(animated: true)
        }
    }

    func startTimer() {
        timer?.invalidate()
        saveStartOfSession()
        let seconds = 600.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        saveStartOfSession()
        timer?.invalidate()
    }
}
