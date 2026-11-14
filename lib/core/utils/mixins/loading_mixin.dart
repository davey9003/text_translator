import 'package:flutter/foundation.dart';

mixin LoadingMixin on ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}


