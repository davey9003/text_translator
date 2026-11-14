abstract class StoragePlatform {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class StoragePlatformImpl implements StoragePlatform {
  // Implementation will use shared_preferences or similar
  @override
  Future<void> saveString(String key, String value) async {
    // TODO: Implement
  }
  
  @override
  Future<String?> getString(String key) async {
    // TODO: Implement
    return null;
  }
  
  @override
  Future<void> remove(String key) async {
    // TODO: Implement
  }
  
  @override
  Future<void> clear() async {
    // TODO: Implement
  }
}


