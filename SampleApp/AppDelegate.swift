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
            options.dsn = "https://bd03859ac43e47f1a74c83a5a2b8614b@o88872.ingest.us.sentry.io/6748045"
            
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
