class Validator {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  static bool isValidTextLength(String text, {int min = 1, int max = 1000}) {
    return text.length >= min && text.length <= max;
  }
}


