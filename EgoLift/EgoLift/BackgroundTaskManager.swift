import BackgroundTasks

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.timer", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.timer")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        TimerManager.shared.loadTimerState()
        task.setTaskCompleted(success: true)
    }
}
