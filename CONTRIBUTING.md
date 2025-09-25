# Contributing to Sentry iOS Bundle Exclusion Reproduction

This repository demonstrates a limitation in Sentry's iOS SDK where UI load spans are not tracked for view controllers located in framework bundles.

## Purpose

This sample app reproduces the issue where:
- ✅ User interactions (`ui.action.click`) are tracked
- ✅ HTTP requests are tracked  
- ❌ UI load spans (`ui.load`) are missing for view controllers in framework bundles

## Architecture

The app uses a **WhiteLabel framework architecture** where:
- Main app bundle contains only `AppDelegate.swift`
- All view controllers are in a separate `WhiteLabel` framework
- Sentry's `UIViewControllerPerformanceTracker` excludes framework view controllers

## Reproducing the Issue

1. **Setup**: Configure your Sentry DSN using `./setup_sentry.sh`
2. **Build**: Run the app on simulator or device
3. **Test**: Navigate through the app and tap buttons
4. **Verify**: Check Sentry dashboard for missing UI load spans

## Expected Behavior

### What Works ✅
- User interaction spans (`ui.action.click`)
- HTTP request spans (`http.client`)
- Error tracking
- Session replay
- Performance monitoring (except UI load spans)

### What's Missing ❌
- UI load spans (`ui.load`) for all view controllers
- View controller lifecycle performance tracking

## Debug Information

With `options.debug = true`, you'll see logs like:
```
[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.AppContainerViewController: 0x...>.
```

## Technical Details

**Root Cause**: Sentry's iOS SDK validates that view controllers are in the main app bundle before tracking them. Framework-based architectures are excluded.

**Impact**: Modern iOS apps using modular architectures (frameworks, Swift packages) lose UI performance visibility.

## Use Cases

- **Sentry Engineers**: Reproduce and debug the bundle exclusion issue
- **Customers**: Demonstrate the limitation with their framework architecture
- **Community**: Understand the technical constraints and potential workarounds

## Related Issues

This reproduces a known limitation in Sentry iOS SDK where:
- Framework-based UI architectures are not supported for UI load span tracking
- Bundle validation prevents tracking of view controllers outside main app bundle
- Modern iOS app architectures are affected

## Contributing

If you find additional scenarios or edge cases:
1. Document the architecture pattern
2. Add test cases to reproduce the issue
3. Update this README with findings
4. Consider potential workarounds or solutions
