import UIKit
import UserNotifications
import NMAKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var router: RootRouter!
    var window: UIWindow?
    
    private let kHelloMapAppID = "wpqy17RvWAkCRGIKRuFE"
    private let kHelloMapAppCode = "zfpnV_IsCCXKfEN91rSZ5g"
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        router.presentWaiter()
    }
}

extension AppDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        AppConfigurator.shared.run()
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 160/255, blue: 160/255, alpha: 1.0)
        let strongWindow = UIWindow(frame: UIScreen.main.bounds)
        self.window = strongWindow
        router = RootRouter(window: strongWindow)
        router.presentInitialViewController()
        
        NMAApplicationContext.set(appId: kHelloMapAppID, appCode: kHelloMapAppCode)
        registerForPushNotifications()
        
        return true
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
                guard granted else { return }
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                })
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print(token)
    }
}
