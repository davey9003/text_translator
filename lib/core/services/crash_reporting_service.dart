abstract class CrashReportingService {
  void recordError(dynamic error, StackTrace? stackTrace, {String? reason});
  void setUserId(String userId);
  void setCustomKey(String key, dynamic value);
}

class CrashReportingServiceImpl implements CrashReportingService {
  @override
  void recordError(dynamic error, StackTrace? stackTrace, {String? reason}) {
    // TODO: Implement using Firebase Crashlytics or similar
  }
  
  @override
  void setUserId(String userId) {
    // TODO: Implement
  }
  
  @override
  void setCustomKey(String key, dynamic value) {
    // TODO: Implement
  }
}


