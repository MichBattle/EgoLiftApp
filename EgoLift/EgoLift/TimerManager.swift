import Foundation

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var timerRunning = false
    @Published var secondsRemaining: Double = 0
    private var timer: Timer?
    
    private init() {
        loadTimerState()
    }
    
    func startTimer(duration: Double) {
        if !timerRunning {
            secondsRemaining = duration
            timerRunning = true
            runTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        clearTimerState()
    }
    
    private func runTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1.0
                self.saveTimerState()
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.timerRunning = false
                self.clearTimerState()
            }
        }
    }
    
    func saveTimerState() {
        UserDefaults.standard.set(secondsRemaining, forKey: "secondsRemaining")
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
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
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func clearTimerState() {
        UserDefaults.standard.removeObject(forKey: "secondsRemaining")
        UserDefaults.standard.removeObject(forKey: "timerRunning")
    }
}
