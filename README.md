# Sentry iOS Bundle Exclusion Reproduction

This is a sample iOS app that demonstrates the missing UI load spans issue in Sentry SDK when view controllers are located in framework bundles rather than the main app bundle.

## Architecture Overview

The app demonstrates a common iOS app architecture where view controllers are organized in separate frameworks:

### App Structure
- **AppDelegate Pattern**: Uses `UIApplicationDelegate` instead of `UIWindowSceneDelegate`
- **WhiteLabel Framework**: Main view controllers are in a separate framework (reproducing the bundle exclusion issue)
- **Coordinator Pattern**: App delegate is thin, most logic resides in `AppCoordinator` (in framework)
- **Programmatic UI**: No storyboards, all UI built programmatically
- **Navigation Hierarchy**: 
  - `WhiteLabel.AppContainerViewController` → `WhiteLabel.TabBarController` → `WhiteLabel.NewShopNavigationController` → `WhiteLabel.NewShopViewController` → `WhiteLabel.ShopTileViewController`
  - Cart flow: `WhiteLabel.URBNNavigationController` → `WhiteLabel.CartViewController` → `WhiteLabel.BasketViewController`

### Key Features
- Sentry SDK integration with performance monitoring enabled
- UI event tracking and performance monitoring
- Cart functionality with sample error simulation
- Complete view hierarchy with navigation flow
- **Framework Architecture**: View controllers in WhiteLabel framework (reproduces bundle exclusion issue)

## Setup Instructions

### 1. Install Dependencies
```bash
# Install Carthage if you haven't already
brew install carthage

# Install Sentry SDK
carthage update --platform iOS
```

### 2. Configure Sentry

#### Option A: Use the setup script (recommended)
```bash
./setup_sentry.sh "https://your-key@your-org.ingest.sentry.io/project-id"
```

#### Option B: Manual configuration
1. Open `SampleApp/AppDelegate.swift`
2. Replace `YOUR_SENTRY_DSN_HERE` with your actual Sentry DSN:
```swift
options.dsn = "https://your-key@your-org.ingest.sentry.io/project-id"
```

### 3. Build and Run
1. Open `SampleApp.xcodeproj` in Xcode
2. Build and run the app on simulator or device
3. Navigate through the app to trigger UI events
4. Tap the cart button to trigger sample errors

## Testing UI Load Spans

### Expected Behavior
When navigating through the app, Sentry should capture UI load spans for:
- `WhiteLabel.AppContainerViewController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.TabBarController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.NewShopNavigationController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.NewShopViewController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.ShopTileViewController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.URBNNavigationController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.CartViewController` ❌ **MISSING** (framework bundle exclusion)
- `WhiteLabel.BasketViewController` ❌ **MISSING** (framework bundle exclusion)

**Note**: All UI load spans will be missing because Sentry excludes view controllers that are not in the main app bundle.

### Reproducing the Issue
1. Launch the app
2. Navigate through different view controllers
3. Tap the cart button (🛒) to trigger sample errors
4. Check Sentry dashboard for UI load spans
5. Look for missing spans in performance monitoring

### Debug Information
The app includes console logging to track view controller appearances:
```
WhiteLabel.AppContainerViewController appeared
WhiteLabel.TabBarController appeared
WhiteLabel.NewShopNavigationController appeared
WhiteLabel.NewShopViewController appeared
WhiteLabel.ShopTileViewController appeared
WhiteLabel.URBNNavigationController appeared
WhiteLabel.CartViewController appeared
WhiteLabel.BasketViewController appeared
```

**Sentry Debug Logs** (with `options.debug = true`):
```
[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.AppContainerViewController: 0x...>.
[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.NewShopViewController: 0x...>.
```

## Sentry Configuration

The app uses a standard Sentry configuration with performance monitoring enabled:

```swift
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
    // Performance monitoring is ENABLED but UI load spans will still be missing
    // due to framework bundle exclusion
    options.tracesSampleRate = 1.0
}
```

### Enabled Features
- Auto session tracking
- Watchdog termination tracking
- View hierarchy capture
- Network tracking
- Frames tracking
- Auto breadcrumb tracking
- App start tracking
- File I/O tracking
- UI event tracking
- Core Data tracking
- Session replay
- Performance monitoring

## Error Simulation

The app includes sample error simulation for testing:

```swift
let error = NSError(
    domain: "URBNApiServices.ApiServiceError",
    code: 5,
    userInfo: [
        NSLocalizedDescriptionKey: "serverResponseError(httpStatusCode: URBNApiServices.HttpStatusCode.preconditionFailed, response: URBNApiServices.ServerResponseError(code: Optional(\"TOKEN_CART_NOT_VALID\"), message: Optional(\"\"), existingResourceId: nil, field_errors: nil)) (Code: 5)"
    ]
)
SentrySDK.captureError(error)
```

## Purpose

This sample app is designed to help reproduce and debug the missing UI load spans issue in Sentry SDK. It demonstrates a common iOS app architecture pattern where view controllers are organized in separate frameworks.

**Key Issue Reproduced**: The app uses a WhiteLabel framework architecture where view controllers are not in the main app bundle. Sentry's UI performance tracker excludes these view controllers from tracking, causing missing UI load spans even when performance monitoring is enabled.

This demonstrates a legitimate limitation in Sentry SDK where modern iOS app architectures using frameworks/modules are not properly supported for UI load span tracking.

## Files Structure

```
SampleApp/
├── AppDelegate.swift                    # Main app delegate with Sentry setup
├── Info.plist                          # App configuration
├── Base.lproj/
│   ├── Main.storyboard                 # Main storyboard (minimal)
│   └── LaunchScreen.storyboard         # Launch screen
├── Assets.xcassets/                     # App assets
└── WhiteLabel/                          # Framework containing view controllers
    └── WhiteLabel/
        ├── WhiteLabel.swift            # Framework main module
        ├── AppCoordinator.swift        # App coordination logic
        ├── AppContainerViewController.swift # Root container view controller
        ├── TabBarController.swift      # Tab bar controller
        ├── NewShopNavigationController.swift # Shop navigation controller
        ├── NewShopViewController.swift # Main shop view controller
        ├── ShopTileViewController.swift # Product detail view controller
        ├── URBNNavigationController.swift # Cart navigation controller
        ├── CartViewController.swift    # Cart view controller
        ├── BasketViewController.swift  # Checkout view controller
        └── CustomViewController.swift  # Test view controller
```

## Troubleshooting

If you encounter build issues:
1. Ensure Carthage dependencies are installed: `carthage update --platform iOS`
2. Check that Sentry framework is properly linked in the project
3. Verify iOS deployment target is 17.0 or higher
4. Make sure you have a valid Sentry DSN configured
5. **Framework Issues**: Ensure the WhiteLabel framework is properly configured in Xcode:
   - Add WhiteLabel as a framework target
   - Link the framework to the main app target
   - Import WhiteLabel in AppDelegate.swift

### Expected Sentry Behavior

**✅ What WILL be tracked:**
- User interactions (`ui.action.click` spans)
- HTTP requests and network operations
- Errors and exceptions
- Session replay
- Performance transactions (but without UI load spans)

**❌ What will NOT be tracked:**
- UI load spans for any view controllers in the WhiteLabel framework
- Performance spans for view controller lifecycle events

**Debug Logs to Look For:**
```
[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.AppContainerViewController: 0x...>.
```
