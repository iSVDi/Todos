import UIKit

//TODO: setup constants enum for whole app
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = TodoListAssembly.getModule()
        window?.makeKeyAndVisible()
        return true
    }
    
}
