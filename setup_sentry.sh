#!/bin/bash

# Setup script for Sentry iOS Bundle Exclusion Reproduction
# This script helps configure your Sentry DSN

echo "🔧 Sentry iOS Bundle Exclusion Reproduction Setup"
echo "================================================="
echo ""

# Check if DSN is provided as argument
if [ $# -eq 1 ]; then
    DSN=$1
else
    echo "Please provide your Sentry DSN:"
    echo "Example: https://your-key@your-org.ingest.sentry.io/project-id"
    read -p "DSN: " DSN
fi

# Validate DSN format
if [[ $DSN =~ ^https://[a-f0-9]+@[a-z0-9.-]+\.ingest\.sentry\.io/[0-9]+$ ]]; then
    echo "✅ Valid DSN format detected"
else
    echo "⚠️  Warning: DSN format doesn't match expected pattern"
    echo "Expected format: https://key@org.ingest.sentry.io/project-id"
    read -p "Continue anyway? (y/n): " continue_setup
    if [ "$continue_setup" != "y" ]; then
        echo "Setup cancelled"
        exit 1
    fi
fi

# Update AppDelegate.swift
APP_DELEGATE="SampleApp/AppDelegate.swift"
if [ -f "$APP_DELEGATE" ]; then
    # Use sed to replace the DSN placeholder
    sed -i.bak "s/YOUR_SENTRY_DSN_HERE/$DSN/g" "$APP_DELEGATE"
    rm "$APP_DELEGATE.bak"
    echo "✅ Updated AppDelegate.swift with your DSN"
else
    echo "❌ AppDelegate.swift not found. Please run this script from the project root."
    exit 1
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Build and run the app: xcodebuild -project SampleApp.xcodeproj -scheme SampleApp build"
echo "2. Navigate through the app to generate traces"
echo "3. Check your Sentry dashboard for missing UI load spans"
echo ""
echo "Expected behavior:"
echo "✅ User interactions will be tracked"
echo "✅ HTTP requests will be tracked"
echo "❌ UI load spans will be missing (this is the issue being reproduced)"
