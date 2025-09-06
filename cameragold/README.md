# Camera Gold - Social Photo Sharing App

Camera Gold là ứng dụng chia sẻ ảnh xã hội với home screen widgets, cho phép bạn chia sẻ khoảnh khắc với bạn bè và nhận thông báo ngay trên màn hình chính.

## ✨ Tính năng chính

- 📸 **Chụp ảnh nhanh**: Mở camera → chụp → gửi cho nhóm/bạn bè
- 📱 **Home Screen Widget**: Hiển thị ảnh mới nhất từ bạn bè ngay trên widget
- 👥 **Nhóm bạn bè**: Tạo nhóm tối đa 20 người, mời qua QR code/link
- ❤️ **Reactions**: 5 loại reaction (❤️ 😂 👍 😮 😢)
- 💬 **Bình luận ngắn**: Tối đa 60 ký tự
- 🔔 **Thông báo đẩy**: Thông báo khi có ảnh mới, reaction, lời mời
- 🌙 **Dark/Light Theme**: Hỗ trợ cả hai chế độ
- 🌐 **Đa ngôn ngữ**: Tiếng Việt và Tiếng Anh

## 📋 Yêu cầu hệ thống

- **Flutter**: 3.13.0+
- **Dart**: 3.1.0+
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: 14.0+
- **Firebase Project**: Với Authentication, Firestore, Storage, Cloud Functions, FCM

## 🚀 Cài đặt & Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd cameragold
```

### 2. Cài đặt Dependencies

```bash
flutter pub get
```

### 3. Setup Firebase

#### 3.1 Tạo Firebase Project

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Tạo project mới tên "camera-gold-app"
3. Bật Authentication, Firestore, Storage, Cloud Functions, Cloud Messaging

#### 3.2 Setup Android

1. **Thêm Android App**:
   - Package name: `com.cameragold.app`
   - Download `google-services.json` → `android/app/`

2. **Thêm SHA-1 fingerprint**:
   ```bash
   # Debug keystore
   keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
   
   # Release keystore (nếu có)
   keytool -list -v -alias <your-alias> -keystore <path-to-keystore>
   ```

3. **Cấu hình Deep Links**:
   - Thêm domain `cameragold.app` vào Firebase Dynamic Links
   - Verify domain ownership

#### 3.3 Setup iOS

1. **Thêm iOS App**:
   - Bundle ID: `com.cameragold.app`
   - Download `GoogleService-Info.plist` → `ios/Runner/`

2. **Team ID Setup**:
   - Thêm Team ID vào Firebase project settings
   - Enable Push Notifications capability

3. **App Groups**:
   - Tạo App Group: `group.com.cameragold.app.widgets`
   - Enable cho cả main app và widget extension

4. **Associated Domains**:
   - Thêm `applinks:cameragold.app`

### 4. Cấu hình Firebase Options

Cập nhật `lib/src/core/config/firebase_options.dart` với keys thực tế từ Firebase Console:

```dart
// Lấy từ Firebase Console → Project Settings → General → Your apps
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: '1:YOUR_PROJECT_NUMBER:android:YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'camera-gold-app',
  storageBucket: 'camera-gold-app.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: '1:YOUR_PROJECT_NUMBER:ios:YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'camera-gold-app',
  storageBucket: 'camera-gold-app.appspot.com',
  iosBundleId: 'com.cameragold.app',
);
```

### 5. Deploy Firestore Rules & Cloud Functions

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Cloud Functions
cd firebase/functions
npm install
cd ../..
firebase deploy --only functions
```

### 6. Setup iOS Widget Extension

#### 6.1 Tạo Widget Extension Target

1. Mở `ios/Runner.xcworkspace` trong Xcode
2. File → New → Target → Widget Extension
3. Tên: `CameraGoldWidget`
4. Bundle ID: `com.cameragold.app.CameraGoldWidget`
5. Thêm vào cùng App Group

#### 6.2 Cấu hình Widget

1. Copy file `ios/CameraGoldWidget/CameraGoldWidget.swift`
2. Thêm Widget Extension vào Signing & Capabilities
3. Enable App Groups cho Widget Extension

### 7. Setup Android Widget

Android Widget đã được cấu hình sẵn trong:
- `android/app/src/main/kotlin/com/cameragold/app/CameraGoldWidgetProvider.kt`
- `android/app/src/main/res/layout/camera_gold_widget.xml`
- `android/app/src/main/res/xml/camera_gold_widget_info.xml`

### 8. Permissions & Assets

#### 8.1 Quyền cần thiết
- ✅ Camera
- ✅ Photo Library/Storage
- ✅ Notifications
- ✅ Internet

#### 8.2 Assets cần thêm

```
assets/
├── images/
│   ├── logo.png
│   ├── placeholder.png
│   └── splash.png
├── icons/
│   ├── ic_camera.png
│   ├── ic_group.png
│   └── ic_notification.png
└── translations/
    ├── vi.json
    └── en.json
```

## 🛠️ Development

### Build & Run

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific platform
flutter run -d ios
flutter run -d android
```

### Code Generation

```bash
# Generate models, providers, etc.
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widgets/
```

## 📦 Build Release

### Android APK/AAB

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS IPA

```bash
# Build iOS
flutter build ios --release

# Archive trong Xcode cho App Store
```

## 🗂️ Cấu trúc Project

```
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── core/
    │   ├── config/
    │   ├── router/
    │   ├── services/
    │   ├── theme/
    │   └── models/
    └── features/
        ├── auth/
        ├── home/
        ├── camera/
        ├── groups/
        ├── photos/
        └── profile/

android/
├── app/
│   ├── src/main/
│   │   ├── kotlin/com/cameragold/app/
│   │   └── res/
│   └── build.gradle

ios/
├── Runner/
└── CameraGoldWidget/

firebase/
├── functions/
└── firestore.rules
```

## 🔧 Cấu hình môi trường

### Development

```bash
# Set environment variables
export FIREBASE_PROJECT_ID=camera-gold-app-dev
export APP_ENV=development

flutter run --dart-define=FIREBASE_PROJECT_ID=camera-gold-app-dev
```

### Production

```bash
export FIREBASE_PROJECT_ID=camera-gold-app
export APP_ENV=production

flutter run --release --dart-define=FIREBASE_PROJECT_ID=camera-gold-app
```

## 📊 Demo Data

Chạy script tạo demo data:

```bash
# Tạo 3 nhóm và 5 ảnh mẫu
firebase firestore:delete --all-collections # Reset data
node scripts/seed_demo_data.js
```

## 🐛 Troubleshooting

### Common Issues

1. **Widget không cập nhật**:
   - Kiểm tra App Group configuration
   - Verify SharedPreferences keys
   - Check widget refresh intervals

2. **FCM không hoạt động**:
   - Verify SHA-1 fingerprints
   - Check google-services.json/GoogleService-Info.plist
   - Test with Firebase Console

3. **Deep Links không hoạt động**:
   - Verify Associated Domains
   - Check URL schemes
   - Test với adb/simctl

4. **Build errors**:
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install && cd ..
   flutter run
   ```

### Debug Commands

```bash
# Check Flutter doctor
flutter doctor -v

# Clear caches
flutter clean
flutter pub cache repair

# Check devices
flutter devices

# View logs
flutter logs

# Firebase debug
firebase debug
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- **Documentation**: [Wiki](https://github.com/your-repo/wiki)
- **Email**: support@cameragold.app

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 🏗️ Architecture

Camera Gold sử dụng Clean Architecture với:
- **Presentation Layer**: Flutter Widgets, Riverpod State Management
- **Domain Layer**: Entities, Use Cases, Repository Interfaces
- **Data Layer**: Firebase Services, Local Storage
- **External**: Firebase, Platform-specific code

## 🔒 Security

- End-to-end validation với Firestore Security Rules
- Image compression trước khi upload
- Rate limiting trong Cloud Functions
- User blocking/reporting system

---

Made with ❤️ by Camera Gold Team
