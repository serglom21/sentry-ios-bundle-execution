# UI Load Spans Testing Guide

This guide helps you test and verify UI load spans behavior in the Sample App.

## Test Scenarios

### 1. Basic Navigation Flow
**Expected UI Load Spans:**
- `AppContainerViewController` (appear)
- `TabBarController` (appear)
- `NewShopNavigationController` (appear)
- `NewShopViewController` (appear)

**Test Steps:**
1. Launch the app
2. Wait for the main interface to load
3. Check Sentry Performance tab for UI load spans

### 2. Product Detail Navigation
**Expected UI Load Spans:**
- `ShopTileViewController` (appear)

**Test Steps:**
1. From the main shop screen, tap "Browse Products"
2. Check Sentry for the new UI load span

### 3. Cart Flow (Error Scenario)
**Expected UI Load Spans:**
- `URBNNavigationController` (appear)
- `CartViewController` (appear)
- `BasketViewController` (appear)

**Test Steps:**
1. From the main shop screen, tap the cart button (🛒)
2. Wait for the cart modal to appear
3. Check Sentry for UI load spans and error capture
4. Look for `TOKEN_CART_NOT_VALID` error

### 4. Complete User Journey
**Expected UI Load Spans (in order):**
1. `AppContainerViewController` (appear)
2. `TabBarController` (appear)
3. `NewShopNavigationController` (appear)
4. `NewShopViewController` (appear)
5. `ShopTileViewController` (appear) - when tapping "Browse Products"
6. `URBNNavigationController` (appear) - when tapping cart
7. `CartViewController` (appear)
8. `BasketViewController` (appear)

**Test Steps:**
1. Launch app
2. Navigate to product details
3. Go back to main shop
4. Open cart
5. Complete the full flow

## Debugging Missing Spans

### Console Output
The app logs view controller appearances to console:
```
AppContainerViewController appeared
TabBarController appeared
NewShopNavigationController appeared
NewShopViewController appeared
ShopTileViewController appeared
URBNNavigationController appeared
CartViewController appeared
BasketViewController appeared
```

### Sentry Debug Mode
With `options.debug = true`, Sentry will log detailed information about:
- Span creation and completion
- UI event tracking
- Performance monitoring
- Error capture

### Common Issues

1. **Missing UI Load Spans**
   - Check if Sentry SDK is properly initialized
   - Verify UI event tracking is enabled
   - Ensure view controllers are properly presented

2. **Incomplete Spans**
   - Check for app crashes or backgrounding
   - Verify view controller lifecycle methods are called
   - Look for timing issues in view presentation

3. **Error Not Captured**
   - Verify DSN is configured
   - Check Sentry debug logs
   - Ensure error is captured after Sentry initialization

## Performance Monitoring

### Expected Metrics
- **UI Load Duration**: Time from viewDidLoad to viewDidAppear
- **Navigation Duration**: Time between view controller transitions
- **Error Rate**: Percentage of failed cart requests

### Key Performance Indicators
- App startup time
- View controller load times
- Network request duration (simulated)
- Error frequency

## Sentry Dashboard Verification

### Performance Tab
Look for these transaction names:
- `ui.action.click` (for cart button taps)
- `ui.load` (for view controller loads)
- `navigation` (for view controller transitions)

### Issues Tab
Look for:
- `TOKEN_CART_NOT_VALID` errors
- Performance issues
- UI-related crashes

### Replays Tab
With session replay enabled, you should see:
- User interactions
- UI state changes
- Error occurrences

## Troubleshooting

### No Spans Appearing
1. Check Sentry DSN configuration
2. Verify network connectivity
3. Check Sentry debug logs
4. Ensure proper Sentry SDK initialization

### Partial Spans
1. Check for app backgrounding during navigation
2. Verify view controller presentation timing
3. Look for memory pressure or crashes

### Missing Errors
1. Verify error simulation is working
2. Check Sentry error capture configuration
3. Ensure error occurs after Sentry initialization

## Expected Behavior vs Issues

### ✅ Expected (Working)
- All view controllers generate UI load spans
- Errors are captured with full context
- Performance metrics are recorded
- Session replay captures user interactions

### ❌ Issues to Report
- Missing UI load spans for specific view controllers
- Incomplete span data
- Errors not being captured
- Performance monitoring gaps
- Session replay not capturing UI events

## Contact Information

If you find issues with UI load spans, please report:
1. Which view controllers are missing spans
2. Console logs from the app
3. Sentry debug output
4. Steps to reproduce
5. Expected vs actual behavior
