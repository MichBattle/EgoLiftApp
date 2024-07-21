import Foundation
import Combine
import UserNotifications

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var timerRunning = false
    @Published var secondsRemaining: Double = 0
    @Published var currentEsercizioID: Int64?
    private var timer: DispatchSourceTimer?
    
    private init() {
        loadTimerState()
    }
    
    func startTimer(duration: Double, for esercizioID: Int64) {
        if !timerRunning {
            secondsRemaining = duration
            timerRunning = true
            currentEsercizioID = esercizioID
            runTimer()
            scheduleNotification()
        }
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
        timerRunning = false
        currentEsercizioID = nil
        clearTimerState()
        removeNotification()
    }
    
    private func runTimer() {
        timer?.cancel()
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1.0
                    self.saveTimerState()
                } else {
                    self.timer?.cancel()
                    self.timer = nil
                    self.timerRunning = false
                    self.currentEsercizioID = nil
                    self.clearTimerState()
                }
            }
        }
        timer?.resume()
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Parti col set"
        content.body = "Riposo finito!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsRemaining, repeats: false)
        let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timerNotification"])
    }
    
    func saveTimerState() {
        UserDefaults.standard.set(secondsRemaining, forKey: "secondsRemaining")
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
        if let currentEsercizioID = currentEsercizioID {
            UserDefaults.standard.set(currentEsercizioID, forKey: "currentEsercizioID")
        }
        UserDefaults.standard.set(Date(), forKey: "lastSavedDate")
    }
    
    func loadTimerState() {
        if let savedSecondsRemaining = UserDefaults.standard.value(forKey: "secondsRemaining") as? Double {
            secondsRemaining = savedSecondsRemaining
        }
        if let savedTimerRunning = UserDefaults.standard.value(forKey: "timerRunning") as? Bool {
            timerRunning = savedTimerRunning
            if timerRunning {
                runTimer()
            }
        }
        if let savedEsercizioID = UserDefaults.standard.value(forKey: "currentEsercizioID") as? Int64 {
            currentEsercizioID = savedEsercizioID
        }
    }
    
    func invalidateTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func clearTimerState() {
        UserDefaults.standard.removeObject(forKey: "secondsRemaining")
        UserDefaults.standard.removeObject(forKey: "timerRunning")
        UserDefaults.standard.removeObject(forKey: "currentEsercizioID")
        UserDefaults.standard.removeObject(forKey: "lastSavedDate")
    }
    
}
