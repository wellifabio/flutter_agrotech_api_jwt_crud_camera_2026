# Image_Picker
- Adicione a dependência **image_picker** em pubspec.yaml
```yaml
environment:
  sdk: ^3.11.5

dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0
  shared_preferences: ^2.5.5
  intl: ^0.20.2
  image_picker: ^1.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.14.4

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icone.png"

flutter:
  uses-material-design: true
  assets:
    - assets/
  fonts:
    - family: PatrickHand
      fonts:
      - asset: assets/fonts/PatrickHand-Regular.ttf
```
- Acrescente a permissão de INTERNET e CAMERA no ./android/app/src/main/AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
```
- Adicionada a descrição de uso da câmera em ./ios/Runner/info.plist
```xml
	<string>Main</string>
	<key>NSCameraUsageDescription</key>
	<string>Este app precisa da camera para tirar foto do animal.</string>
```