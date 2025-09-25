#!/bin/bash

echo "Setting up Sample App..."

# Check if Carthage is installed
if ! command -v carthage &> /dev/null; then
    echo "Carthage is not installed. Installing via Homebrew..."
    brew install carthage
fi

# Install Sentry SDK
echo "Installing Sentry SDK..."
carthage update --platform iOS

echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open SampleApp.xcodeproj in Xcode"
echo "2. Add your Sentry DSN to AppDelegate.swift"
echo "3. Build and run the app"
echo "4. Navigate through the app to test UI load spans"
