#!/bin/bash

# Camera Gold Setup Script
# This script helps setup the Camera Gold project

echo "🚀 Camera Gold Setup Script"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Flutter is installed
echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed. Please install Flutter first:"
    echo "https://docs.flutter.dev/get-started/install"
    exit 1
else
    print_step "Flutter is installed"
    flutter --version
fi

# Check if Firebase CLI is installed
echo ""
echo "Checking Firebase CLI installation..."
if ! command -v firebase &> /dev/null; then
    print_warning "Firebase CLI is not installed."
    echo "Installing Firebase CLI..."
    npm install -g firebase-tools
    if [ $? -eq 0 ]; then
        print_step "Firebase CLI installed successfully"
    else
        print_error "Failed to install Firebase CLI"
        exit 1
    fi
else
    print_step "Firebase CLI is installed"
fi

# Get dependencies
echo ""
echo "Getting Flutter dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    print_step "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Check for Firebase configuration
echo ""
echo "Checking Firebase configuration..."
if [ ! -f "lib/src/core/config/firebase_options.dart" ]; then
    print_error "Firebase options not found!"
    echo "Please run 'flutterfire configure' to setup Firebase"
else
    print_step "Firebase options file found"
fi

# Check for google-services.json (Android)
if [ ! -f "android/app/google-services.json" ]; then
    print_warning "google-services.json not found for Android"
    echo "Please download from Firebase Console and place in android/app/"
else
    print_step "Android google-services.json found"
fi

# Check for GoogleService-Info.plist (iOS)
if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    print_warning "GoogleService-Info.plist not found for iOS"
    echo "Please download from Firebase Console and place in ios/Runner/"
else
    print_step "iOS GoogleService-Info.plist found"
fi

# Setup Firebase Functions
echo ""
echo "Setting up Firebase Functions..."
if [ -d "firebase/functions" ]; then
    cd firebase/functions
    if [ ! -f "package.json" ]; then
        print_error "Firebase Functions package.json not found"
    else
        echo "Installing Firebase Functions dependencies..."
        npm install
        if [ $? -eq 0 ]; then
            print_step "Firebase Functions dependencies installed"
        else
            print_error "Failed to install Firebase Functions dependencies"
        fi
    fi
    cd ../..
else
    print_warning "Firebase functions directory not found"
fi

# Generate code (if build_runner is configured)
echo ""
echo "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs
if [ $? -eq 0 ]; then
    print_step "Code generation completed"
else
    print_warning "Code generation failed (this might be normal if no code generation is needed)"
fi

# Check iOS setup (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo ""
    echo "Checking iOS setup..."
    if [ -d "ios" ]; then
        cd ios
        echo "Installing iOS dependencies..."
        pod install
        if [ $? -eq 0 ]; then
            print_step "iOS dependencies installed"
        else
            print_warning "iOS pod install failed"
        fi
        cd ..
    fi
fi

# Setup complete
echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo "1. Configure Firebase project:"
echo "   - Run 'flutterfire configure' if not done already"
echo "   - Add SHA-1 fingerprints to Firebase Console"
echo "   - Download and place google-services.json and GoogleService-Info.plist"
echo ""
echo "2. Deploy Firebase services:"
echo "   - firebase deploy --only firestore:rules"
echo "   - firebase deploy --only functions"
echo ""
echo "3. Setup iOS Widget Extension (if needed):"
echo "   - Open ios/Runner.xcworkspace in Xcode"
echo "   - Add Widget Extension target"
echo "   - Configure App Groups"
echo ""
echo "4. Test the app:"
echo "   - flutter run"
echo ""
echo "5. Seed demo data (optional):"
echo "   - Download service account key from Firebase Console"
echo "   - Place in scripts/service-account-key.json"
echo "   - Run: cd scripts && node seed_demo_data.js"
echo ""
print_step "Ready to start developing Camera Gold! 📸✨"
