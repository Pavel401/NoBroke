# GrowthApp Release Configurations

This document outlines the optimized release configurations for Android and iOS builds of GrowthApp.

## 🚀 Quick Start

### Building Optimized Releases

```bash
# Build all optimized releases
./build-release.sh

# Or build individually:
flutter build apk --release --tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols/
flutter build appbundle --release --tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols/
flutter build ios --release --tree-shake-icons --obfuscate --split-debug-info=build/ios/symbols/
```

## 📱 Android Configuration

### Release Signing

1. Generate a release keystore:
   ```bash
   ./generate-keystore.sh
   ```

2. The script creates:
   - `android/app/growthapp-release.keystore` (keep secure!)
   - `android/key.properties` (keep secure!)

### Optimizations Applied

- **Code Shrinking**: R8 with ProGuard rules
- **Resource Shrinking**: Removes unused resources
- **Code Obfuscation**: Makes reverse engineering harder
- **ABI Filtering**: Only includes arm64-v8a, armeabi-v7a, x86_64
- **Debug Info Splitting**: Reduces APK size, enables crash symbolication
- **Tree Shaking**: Removes unused icons and code

### Build Outputs

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab` (for Play Store)
- **Symbols**: `build/app/outputs/symbols/` (for crash reporting)

## 🍎 iOS Configuration

### Optimizations Applied

- **Whole Module Optimization**: Swift compiler optimization
- **Link Time Optimization**: LLVM LTO enabled
- **Dead Code Stripping**: Removes unused code
- **Size Optimization**: GCC optimization level set to 's'
- **Symbol Stripping**: Release builds strip debug symbols

### Building for Release

1. Ensure iOS dependencies are updated:
   ```bash
   cd ios && pod install --repo-update && cd ..
   ```

2. Build release IPA:
   ```bash
   flutter build ios --release --tree-shake-icons --obfuscate --split-debug-info=build/ios/symbols/
   ```

3. Open `ios/Runner.xcworkspace` in Xcode to create archive for App Store

## 📊 Size Optimization Features

### Flutter Level
- **Tree Shaking**: `--tree-shake-icons` removes unused Material icons
- **Code Obfuscation**: `--obfuscate` makes code harder to reverse engineer
- **Debug Info Splitting**: `--split-debug-info` reduces app size while maintaining crash reporting
- **Asset Optimization**: Only includes necessary assets

### Android Specific
- **R8 Optimization**: Advanced code shrinking and obfuscation
- **Resource Shrinking**: Removes unused resources automatically
- **APK Optimization**: ZIP alignment and compression
- **MultiDex**: Enabled for large applications

### iOS Specific
- **LLVM Optimizations**: Link-time optimizations enabled
- **Swift Optimizations**: Whole module optimization
- **Bitcode**: Disabled (not needed for modern iOS)

## 🔧 Build Scripts

### `build-release.sh`
Comprehensive build script that:
- Cleans previous builds
- Updates dependencies
- Builds optimized APK and App Bundle
- Builds iOS release (on macOS)
- Shows build sizes and next steps

### `generate-keystore.sh`
Interactive script to generate Android release keystore with proper security settings.

## 📈 Expected Size Improvements

The optimizations typically reduce app size by:
- **30-50%** for Android APK
- **40-60%** for Android App Bundle
- **20-40%** for iOS IPA

## ⚠️ Security Notes

**NEVER commit these files to version control:**
- `android/key.properties`
- `android/app/*.keystore`
- `android/app/*.jks`

These files are automatically added to `.gitignore`.

## 🔍 Debugging Release Builds

### Crash Reporting
Symbol files are generated in:
- Android: `build/app/outputs/symbols/`
- iOS: `build/ios/symbols/`

Upload these to your crash reporting service (Firebase Crashlytics, etc.) to get meaningful stack traces.

### Testing Release Builds

```bash
# Install release APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Test on iOS Simulator (debug build)
flutter run --release
```

## 📋 Checklist Before Release

- [ ] Test release builds on physical devices
- [ ] Verify all features work in release mode
- [ ] Check app size is acceptable
- [ ] Upload symbol files to crash reporting
- [ ] Test obfuscated code doesn't break functionality
- [ ] Verify signing configurations
- [ ] Test app bundle on Play Console internal testing
- [ ] Test iOS archive uploads to TestFlight

## 🛠 Troubleshooting

### Common Issues

1. **ProGuard rules too aggressive**: Check `android/app/proguard-rules.pro`
2. **Missing symbols**: Ensure debug info splitting path is correct
3. **iOS build failures**: Run `flutter clean` and `pod install --repo-update`
4. **Large app size**: Review unused dependencies in `pubspec.yaml`

### Performance Monitoring

Monitor app size over time:
```bash
# Check APK size
du -h build/app/outputs/flutter-apk/app-release.apk

# Analyze APK contents
flutter build apk --analyze-size
```