import SwiftUI
import UserNotifications

@main
struct EgoLiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Handle granted
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TimerManager.shared.saveTimerState()
        BackgroundTaskManager.shared.scheduleAppRefresh()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        TimerManager.shared.updateRemainingTime()
        TimerManager.shared.loadTimerState()
    }
}
