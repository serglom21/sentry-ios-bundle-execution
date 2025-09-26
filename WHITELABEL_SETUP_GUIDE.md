# WhiteLabel Framework Setup Guide

## Step-by-Step Xcode Setup

### 1. Open the Project
- Open `SampleApp.xcodeproj` in Xcode

### 2. Create Framework Target
- Go to **File → New → Target**
- Choose **Framework** under iOS
- Product Name: `WhiteLabel`
- Language: **Swift**
- Click **Finish**
- When prompted "Activate scheme?", click **Activate**

### 3. Add Framework Files
- In the Project Navigator, right-click on the **WhiteLabel** target
- Choose **Add Files to "WhiteLabel"**
- Navigate to the `WhiteLabel/WhiteLabel/` directory
- Select **ALL** the .swift files:
  - `WhiteLabel.swift`
  - `AppCoordinator.swift`
  - `AppContainerViewController.swift`
  - `TabBarController.swift`
  - `NewShopNavigationController.swift`
  - `NewShopViewController.swift`
  - `ShopTileViewController.swift`
  - `NavigationController.swift`
  - `CartViewController.swift`
  - `BasketViewController.swift`
  - `CustomViewController.swift`
- Make sure **"Add to target: WhiteLabel"** is checked
- Click **Add**

### 4. Link Framework to Main App
- Select the **SampleApp** target in the Project Navigator
- Go to the **Build Phases** tab
- Expand **Link Binary With Libraries**
- Click the **+** button
- Select **WhiteLabel.framework** from the list
- Click **Add**

### 5. Update Build Settings
- Select the **WhiteLabel** target
- Go to the **Build Settings** tab
- Search for "iOS Deployment Target"
- Set it to **17.0**
- Search for "Build Libraries for Distribution"
- Set it to **Yes**

### 6. Clean Up Old References (if needed)
If you see build errors about missing files:
- Select the **SampleApp** target
- Go to **Build Phases → Compile Sources**
- Remove any references to the old view controller files that no longer exist

### 7. Build and Test
- **Product → Clean Build Folder**
- **Product → Build**
- If successful, **Product → Run**

## Expected Results

### ✅ Success Indicators:
1. **Build succeeds** without errors
2. **App launches** and shows the sample app interface
3. **Console shows** view controller appearance logs:
   ```
   WhiteLabel.AppContainerViewController appeared
   WhiteLabel.TabBarController appeared
   WhiteLabel.NewShopViewController appeared
   ```

### 🎯 Sentry Debug Logs (with debug enabled):
```
[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.AppContainerViewController: 0x...>.
[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.NewShopViewController: 0x...>.
```

### ❌ What You Should NOT See:
- UI load spans in Sentry Performance tab
- Performance transactions for view controller loads

### ✅ What You SHOULD See:
- User interaction spans (`ui.action.click`)
- HTTP request spans
- Error capture (when you tap the cart button)
- Session replay data

## Troubleshooting

### Build Errors:
- **"No such module 'WhiteLabel'"**: Make sure the framework is linked in Build Phases
- **"Use of unresolved identifier"**: Check that all files are added to the WhiteLabel target
- **"Missing required module"**: Clean build folder and rebuild

### Runtime Issues:
- **App crashes on launch**: Check that AppDelegate imports WhiteLabel correctly
- **No console logs**: Verify view controllers are being created from the framework

## Verification Steps

1. **Run the app** and navigate through different screens
2. **Check Xcode console** for the "WhiteLabel.XYZViewController appeared" logs
3. **Check Sentry debug logs** for the bundle exclusion messages
4. **Verify in Sentry dashboard** that UI load spans are missing
5. **Confirm other tracking works** (user interactions, HTTP requests, errors)

This setup reproduces the exact issue where UI load spans are missing due to framework bundle exclusion!
