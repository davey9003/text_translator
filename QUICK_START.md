# Quick Start - Translation API Configuration

## 🚀 Fastest Setup (No API Key Required)

The app is pre-configured to use **LibreTranslate** - a free, open-source translation service. No setup needed!

Just run:
```bash
flutter run
```

## 📝 Change Translation Provider

Edit `lib/core/config/translation_api_config.dart`:

### Option 1: LibreTranslate (Default - Free, No API Key)
```dart
static const TranslationProvider provider = TranslationProvider.libreTranslate;
```

### Option 2: MyMemory (Free Tier - 10,000 words/day)
```dart
static const TranslationProvider provider = TranslationProvider.myMemory;
```

### Option 3: Google Cloud Translation (Requires API Key)
```dart
static const TranslationProvider provider = TranslationProvider.googleCloud;
static const String apiKey = 'YOUR_GOOGLE_CLOUD_API_KEY';
```

### Option 4: Custom API
```dart
static const TranslationProvider provider = TranslationProvider.custom;
static const String customApiUrl = 'https://your-api.com';
static const String apiKey = 'YOUR_API_KEY'; // If required
```

## 🔑 Setting API Key via Environment Variable

### For Development:
```bash
flutter run --dart-define=TRANSLATION_API_KEY=your_key_here
```

### For Production Build:
```bash
flutter build apk --dart-define=TRANSLATION_API_KEY=your_key_here
```

## ✅ Current Configuration

Check `lib/core/config/translation_api_config.dart` to see your current setup:
- **Provider**: `TranslationProvider.libreTranslate` (default)
- **Base URL**: Automatically set based on provider
- **API Key**: Not required for LibreTranslate/MyMemory

## 🧪 Test Your Configuration

1. Run the app: `flutter run`
2. Capture text with camera
3. Try translating - if it works, configuration is correct!

## 📚 Full Documentation

See `TRANSLATION_API_SETUP.md` for detailed setup instructions for each provider.













