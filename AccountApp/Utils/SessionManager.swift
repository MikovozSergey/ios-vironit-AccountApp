import UIKit

final public class SessionManager {
 
    weak var timer: Timer?
    weak var viewModel: SettingsViewModel?
    
    func startTimer() {
        timer?.invalidate()
        saveStartOfSession()
        let seconds = 600.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer?.invalidate()
    }
    
    private func currentTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        print("CurrentTime = \(Date(timeInterval: seconds, since: Date()))")
        return Date(timeInterval: seconds, since: Date())
    }
    
    private func saveStartOfSession() {
        let defaults = UserDefaults.standard
        print("TimeOfStartSession = \(currentTime())")
        defaults.set(currentTime(), forKey: "timeOfStartSession")
    }
    
    private func getStartOfSession() -> Date {
        guard let date = UserDefaults.standard.object(forKey: "timeOfStartSession") as? Date else { return Date() }
        return date
    }
    
    private func isEndOfSession(startOfSession: Date) -> Bool {
        let finishDate = startOfSession.addingTimeInterval(240.0 * 60.0)
        let currentTime = currentTime()
        print("Start: \(currentTime) \nFinish: \(finishDate)")
        if finishDate > currentTime { return false } else { return true }
    }

    @objc func timerHandler(_ timer: Timer) {
        if isEndOfSession(startOfSession: getStartOfSession()) {
            stopTimer()
            viewModel?.steps.accept(SettingsStep.logoutStep)
        }
    }
}
