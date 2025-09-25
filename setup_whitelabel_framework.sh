#!/bin/bash

# WhiteLabel Framework Setup Script
# This script helps set up the WhiteLabel framework target in Xcode

echo "🚀 Setting up WhiteLabel Framework for Sample App"
echo "=============================================================="

# Check if we're in the right directory
if [ ! -f "SampleApp.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Please run this script from the ios-uikit directory"
    exit 1
fi

echo "✅ Found Xcode project"

# Create framework directory structure if it doesn't exist
if [ ! -d "WhiteLabel" ]; then
    echo "❌ Error: WhiteLabel directory not found. Please ensure the framework files are created."
    exit 1
fi

echo "✅ Found WhiteLabel framework directory"

# List the framework files
echo ""
echo "📁 Framework files to add to Xcode:"
echo "===================================="
find WhiteLabel -name "*.swift" | while read file; do
    echo "  - $file"
done

echo ""
echo "📋 Manual Steps Required in Xcode:"
echo "=================================="
echo ""
echo "1. Open SampleApp.xcodeproj in Xcode"
echo ""
echo "2. Create Framework Target:"
echo "   - File → New → Target"
echo "   - Choose 'Framework' under iOS"
echo "   - Product Name: 'WhiteLabel'"
echo "   - Language: Swift"
echo "   - Click 'Finish'"
echo ""
echo "3. Add Framework Files:"
echo "   - Right-click on WhiteLabel target"
echo "   - Choose 'Add Files to WhiteLabel'"
echo "   - Navigate to WhiteLabel/WhiteLabel/ directory"
echo "   - Select all .swift files"
echo "   - Make sure 'Add to target: WhiteLabel' is checked"
echo "   - Click 'Add'"
echo ""
echo "4. Link Framework to Main App:"
echo "   - Select SampleApp target"
echo "   - Go to 'Build Phases' tab"
echo "   - Expand 'Link Binary With Libraries'"
echo "   - Click '+' and add 'WhiteLabel.framework'"
echo ""
echo "5. Update Build Settings:"
echo "   - Select WhiteLabel target"
echo "   - Go to 'Build Settings' tab"
echo "   - Set 'iOS Deployment Target' to 17.0"
echo "   - Set 'Build Libraries for Distribution' to 'Yes'"
echo ""
echo "6. Clean and Build:"
echo "   - Product → Clean Build Folder"
echo "   - Product → Build"
echo ""
echo "🎯 Expected Result:"
echo "=================="
echo "When you run the app, you should see Sentry debug logs like:"
echo "[Sentry] [debug] [SentryUIViewControllerPerformanceTracker:92] Won't track view controller that is not part of the app bundle: <WhiteLabel.AppContainerViewController: 0x...>."
echo ""
echo "This confirms that UI load spans are missing due to framework bundle exclusion!"
echo ""
echo "✨ Setup complete! Follow the manual steps above in Xcode."
