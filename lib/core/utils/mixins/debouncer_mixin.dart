import 'dart:async';
import 'package:flutter/material.dart';

mixin DebouncerMixin {
  Timer? _debounceTimer;
  
  void debounce(Duration duration, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }
  
  void cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}

