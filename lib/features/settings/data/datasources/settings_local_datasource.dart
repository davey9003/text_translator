import '../../../../core/services/storage_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/app_settings_model.dart';
import 'dart:convert';

abstract class SettingsLocalDataSource {
  Future<AppSettingsModel> getSettings();
  Future<void> saveSettings(AppSettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final StorageService storageService;
  
  SettingsLocalDataSourceImpl(this.storageService);
  
  @override
  Future<AppSettingsModel> getSettings() async {
    try {
      final jsonString = await storageService.get<String>(AppConstants.settingsKey);
      if (jsonString == null) {
        return AppSettingsModel.defaultSettings();
      }
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettingsModel.fromJson(json);
    } catch (e) {
      throw CacheException('Failed to get settings: $e');
    }
  }
  
  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    try {
      final jsonString = jsonEncode(settings.toJson());
      await storageService.save(AppConstants.settingsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save settings: $e');
    }
  }
}


