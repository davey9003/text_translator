# Translation API Configuration Guide

This guide explains how to configure the translation API endpoint for the Lens Translate app.

## Supported Translation Providers

The app supports multiple translation API providers:

1. **LibreTranslate** (Recommended for free tier)
   - Free and open-source
   - No API key required
   - Public instance: https://libretranslate.com
   - Rate limits apply

2. **MyMemory Translation API**
   - Free tier available (10,000 words/day)
   - No API key required for free tier
   - Good for testing and small projects

3. **Google Cloud Translation API**
   - Requires API key and billing account
   - High accuracy and reliability
   - Paid service with free tier

4. **Custom API**
   - Use your own translation API endpoint
   - Requires API key if your service needs authentication

## Configuration Steps

### Step 1: Choose Your Provider

Edit `lib/core/config/translation_api_config.dart`:

```dart
static const TranslationProvider provider = TranslationProvider.libreTranslate;
```

Change to:
- `TranslationProvider.libreTranslate` - For LibreTranslate
- `TranslationProvider.myMemory` - For MyMemory
- `TranslationProvider.googleCloud` - For Google Cloud
- `TranslationProvider.custom` - For custom API

### Step 2: Set API Key (if required)

#### Option A: Environment Variables (Recommended)

Create a `.env` file in the project root:

```env
TRANSLATION_API_KEY=your_api_key_here
TRANSLATION_API_URL=https://your-custom-api.com  # Only for custom provider
```

Then run with:
```bash
flutter run --dart-define=TRANSLATION_API_KEY=your_key
```

#### Option B: Direct Configuration

Edit `lib/core/config/translation_api_config.dart`:

```dart
static const String apiKey = 'your_api_key_here';
```

**⚠️ Warning**: Don't commit API keys to version control!

### Step 3: Provider-Specific Setup

#### LibreTranslate (No Setup Required)
- Default provider
- No API key needed
- Ready to use immediately

#### MyMemory (No Setup Required)
- No API key needed for free tier
- 10,000 words/day limit
- Ready to use immediately

#### Google Cloud Translation API

1. **Create a Google Cloud Project**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one

2. **Enable Translation API**
   - Navigate to "APIs & Services" > "Library"
   - Search for "Cloud Translation API"
   - Click "Enable"

3. **Create API Key**
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "API Key"
   - Copy the API key

4. **Set API Key**
   ```dart
   static const String apiKey = 'your_google_cloud_api_key';
   ```

5. **Set Provider**
   ```dart
   static const TranslationProvider provider = TranslationProvider.googleCloud;
   ```

#### Custom API

1. **Set Custom URL**
   ```dart
   static const String customApiUrl = 'https://your-api.com';
   ```

2. **Set Provider**
   ```dart
   static const TranslationProvider provider = TranslationProvider.custom;
   ```

3. **API Endpoint Format**
   Your API should accept POST requests to `/v1/translate` with:
   ```json
   {
     "text": "Hello",
     "sourceLanguage": "en",
     "targetLanguage": "es"
   }
   ```
   
   And return:
   ```json
   {
     "translatedText": "Hola"
   }
   ```

## Testing the Configuration

After configuration, test the API:

1. Run the app:
   ```bash
   flutter run
   ```

2. Try translating some text
3. Check the console for any API errors

## Troubleshooting

### "API key required" Error
- Make sure you've set the API key if using Google Cloud or Custom provider
- Check that `TranslationApiConfig.hasApiKey` returns `true`

### "Translation failed" Error
- Check your internet connection
- Verify the API endpoint URL is correct
- Check API key validity (for Google Cloud)
- Review API rate limits (especially for free tiers)

### LibreTranslate Rate Limits
- Public instance has rate limits
- Consider hosting your own LibreTranslate instance for production

## Environment Variables for Production

For production, use environment variables:

```bash
# Build command
flutter build apk --dart-define=TRANSLATION_API_KEY=your_key --dart-define=TRANSLATION_API_URL=https://api.example.com
```

Or use a `.env` file with `flutter_dotenv` package.

## Recommended Setup

**For Development/Testing:**
- Use `TranslationProvider.libreTranslate` (no setup needed)

**For Production:**
- Use `TranslationProvider.googleCloud` (reliable, accurate)
- Or host your own LibreTranslate instance

## API Response Formats

The service handles different response formats automatically:

- **LibreTranslate**: `{"translatedText": "..."}`
- **MyMemory**: `{"responseData": {"translatedText": "..."}}`
- **Google Cloud**: `{"data": {"translations": [{"translatedText": "..."}]}}`
- **Custom**: `{"translatedText": "..."}`

## Next Steps

1. Choose your provider
2. Configure API key if needed
3. Test the translation functionality
4. Monitor API usage and costs (if applicable)













