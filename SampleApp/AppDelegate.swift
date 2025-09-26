import UIKit
import Sentry
import WhiteLabel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: WhiteLabel.AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Sentry SDK early in app startup
        initializeSentry()
        
        // Create main window programmatically (no storyboards)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        
        // Initialize app coordinator from WhiteLabel framework
        appCoordinator = WhiteLabel.AppCoordinator(window: window!)
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func initializeSentry() {
        // REPRODUCING CUSTOMER ISSUE: Missing UI load spans due to framework bundle exclusion
        // This configuration enables performance monitoring but UI load spans will still be missing
        // because the view controllers are in the WhiteLabel framework (not main app bundle)
        SentrySDK.start { options in
            options.dsn = "YOUR_SENTRY_DSN_HERE"
            
            #if RELEASE
            options.environment = "production"
            options.sessionReplay.onErrorSampleRate = 1.0
            options.sessionReplay.sessionSampleRate = 0.1
            #else
            options.environment = "development"
            options.debug = true
            options.sessionReplay.onErrorSampleRate = 1.0
            options.sessionReplay.sessionSampleRate = 1.0
            #endif
            
            // ENABLE performance monitoring
            // UI load spans will still be missing due to framework bundle exclusion
            options.tracesSampleRate = 1.0
            options.enableAutoSessionTracking = true
            options.enableWatchdogTerminationTracking = true
            options.enableAutoBreadcrumbTracking = true
        }
    }

    
    // MARK: - App Coordinator Helper
    func showCart() {
        appCoordinator?.showCart()
    }
}
