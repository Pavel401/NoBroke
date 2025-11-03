#!/bin/bash

# GrowthApp Release Build Script
# This script creates optimized release builds for Android and iOS

set -e

echo "🚀 GrowthApp Release Build Script"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

print_status "Dependencies updated"

# Build Android Release
echo ""
echo "📱 Building Android Release..."
echo "============================="

if [ -f "android/key.properties" ]; then
    print_status "Found release keystore, building signed APK..."
    flutter build apk \
        --release \
        --tree-shake-icons \
        --obfuscate \
        --split-debug-info=build/app/outputs/symbols/ \
        --target-platform android-arm,android-arm64,android-x64
    
    print_status "Signed APK built successfully!"
    echo "📁 Location: build/app/outputs/flutter-apk/app-release.apk"
else
    print_warning "No release keystore found. Building with debug signing..."
    print_warning "Run ./generate-keystore.sh to create a release keystore"
    flutter build apk \
        --release \
        --tree-shake-icons \
        --obfuscate \
        --split-debug-info=build/app/outputs/symbols/ \
        --target-platform android-arm,android-arm64,android-x64
    
    print_status "Debug-signed APK built successfully!"
    echo "📁 Location: build/app/outputs/flutter-apk/app-release.apk"
fi

# Build Android App Bundle (for Play Store)
echo ""
echo "📦 Building Android App Bundle..."
flutter build appbundle \
    --release \
    --tree-shake-icons \
    --obfuscate \
    --split-debug-info=build/app/outputs/symbols/ \
    --target-platform android-arm,android-arm64,android-x64

print_status "App Bundle built successfully!"
echo "📁 Location: build/app/outputs/bundle/release/app-release.aab"

# Build iOS Release (if on macOS) - COMMENTED OUT
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     echo ""
#     echo "🍎 Building iOS Release..."
#     echo "=========================="
#     
#     cd ios
#     pod install --repo-update
#     cd ..
#     
#     flutter build ios \
#         --release \
#         --tree-shake-icons \
#         --obfuscate \
#         --split-debug-info=build/ios/symbols/
#     
#     print_status "iOS build completed!"
#     print_warning "Open ios/Runner.xcworkspace in Xcode to create IPA for App Store"
# else
#     print_warning "iOS build skipped (not on macOS)"
# fi

# Build info
echo ""
echo "📊 Build Information"
echo "===================="
echo "Build Mode: Release"
echo "Tree Shake Icons: Enabled"
echo "Code Obfuscation: Enabled"
echo "Debug Info Split: Enabled"

# Show file sizes
echo ""
echo "📏 Build Sizes"
echo "=============="

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "APK Size: $APK_SIZE"
fi

if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
    echo "App Bundle Size: $AAB_SIZE"
fi

echo ""
print_status "All builds completed successfully! 🎉"
echo ""
echo "Next steps:"
echo "• Test the APK: adb install build/app/outputs/flutter-apk/app-release.apk"
echo "• Upload App Bundle to Play Console: build/app/outputs/bundle/release/app-release.aab"
# echo "• Archive iOS app in Xcode for App Store submission" - COMMENTED OUT