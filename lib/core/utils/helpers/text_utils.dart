class TextUtils {
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  static bool isValidText(String text) {
    return text.trim().isNotEmpty;
  }
  
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}


