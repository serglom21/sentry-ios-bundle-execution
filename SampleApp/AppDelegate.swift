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
        // SOLUTION IMPLEMENTED: Fixed missing UI load spans for framework bundle view controllers
        // Using inAppInclude to tell Sentry that WhiteLabel framework is part of the application
        // This enables UI load spans and proper performance monitoring for framework view controllers
        SentrySDK.start { options in
            options.dsn = ""
            
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
            
            // SOLUTION: Include framework modules as part of the application
            // This enables UI load spans for view controllers in framework bundles
            options.add(inAppInclude: "WhiteLabel")
            
            // ENABLE performance monitoring
            // UI load spans will now be generated for framework view controllers
            options.tracesSampleRate = 1.0
            options.enableAutoSessionTracking = true
            options.enableWatchdogTerminationTracking = true
            options.enableAutoBreadcrumbTracking = true
            
            #if DEBUG
            // Show Session Replay masking preview for debugging
            // This will display an overlay showing which elements are masked
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                SentrySDK.replay.showMaskPreview(0.3) // 30% opacity for semi-transparent preview
            }
            #endif
        }
    }

    
    // MARK: - App Coordinator Helper
    func showCart() {
        appCoordinator?.showCart()
    }
}
