import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../error/exceptions.dart';

abstract class StorageService {
  Future<void> save<T>(String key, T value);
  Future<T?> get<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;
  
  StorageServiceImpl(this._prefs);
  
  @override
  Future<void> save<T>(String key, T value) async {
    try {
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      } else {
        // For complex types, serialize to JSON
        await _prefs.setString(key, jsonEncode(value));
      }
    } catch (e) {
      throw StorageException('Failed to save: $e');
    }
  }
  
  @override
  Future<T?> get<T>(String key) async {
    try {
      if (T == String) {
        return _prefs.getString(key) as T?;
      } else if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == List<String>) {
        return _prefs.getStringList(key) as T?;
      } else {
        // For complex types, deserialize from JSON
        final jsonString = _prefs.getString(key);
        if (jsonString == null) return null;
        return jsonDecode(jsonString) as T;
      }
    } catch (e) {
      throw StorageException('Failed to get: $e');
    }
  }
  
  @override
  Future<void> delete(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw StorageException('Failed to delete: $e');
    }
  }
  
  @override
  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear: $e');
    }
  }
}


