import UIKit

final public class SessionManager {
 
    let defaults = UserDefaults.standard
    weak var timer: Timer?
    weak var viewModel: SettingsViewModel?
    
    func startTimer() {
        timer?.invalidate()
        saveStartOfSession()
        let seconds = 600.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        print("Stop Timer = \(currentTime())")
        timer?.invalidate()
    }
    
    private func currentTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        return Date(timeInterval: seconds, since: Date())
    }
    
    private func saveStartOfSession() {
        print("StartOfSession = \(currentTime())")
        defaults.set(currentTime(), forKey: "timeOfStartSession")
    }
    
    private func getStartOfSession() -> Date {
        guard let date = defaults.object(forKey: "timeOfStartSession") as? Date else {
            print("\n LOG can’t get date from UserDefaults object")
            return Date() }
        return date
    }
    
    private func isEndOfSession(startOfSession: Date) -> Bool {
        let finishDate = startOfSession.addingTimeInterval(240.0 * 60.0)
        print("StartTimeOfSession: \(startOfSession) \nCurrentTime: \(currentTime()) \nFinishOfSession: \(finishDate)")
        if finishDate > currentTime() { return false } else { return true }
    }

    @objc func timerHandler(_ timer: Timer) {
        if isEndOfSession(startOfSession: getStartOfSession()) {
            stopTimer()
            viewModel?.steps.accept(SettingsStep.logoutStep)
        }
    }
}
