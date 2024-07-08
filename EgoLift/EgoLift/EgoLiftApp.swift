import SwiftUI

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
    func applicationDidEnterBackground(_ application: UIApplication) {
        TimerManager.shared.saveTimerState()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        TimerManager.shared.loadTimerState()
    }
}
