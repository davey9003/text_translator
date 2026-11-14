import '../../../../core/services/storage_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/translation_model.dart';
import 'dart:convert';

abstract class TranslationLocalDataSource {
  Future<List<TranslationModel>> getHistory();
  Future<void> saveTranslation(TranslationModel translation);
  Future<void> deleteTranslation(String id);
  Future<void> clearHistory();
}

class TranslationLocalDataSourceImpl implements TranslationLocalDataSource {
  final StorageService storageService;
  
  TranslationLocalDataSourceImpl(this.storageService);
  
  @override
  Future<List<TranslationModel>> getHistory() async {
    try {
      final jsonString = await storageService.get<String>(AppConstants.historyKey);
      if (jsonString == null) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => TranslationModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException('Failed to get history: $e');
    }
  }
  
  @override
  Future<void> saveTranslation(TranslationModel translation) async {
    try {
      final history = await getHistory();
      history.insert(0, translation);
      // Limit history size
      if (history.length > AppConstants.maxHistoryItems) {
        history.removeRange(AppConstants.maxHistoryItems, history.length);
      }
      final jsonString = jsonEncode(history.map((t) => t.toJson()).toList());
      await storageService.save(AppConstants.historyKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save translation: $e');
    }
  }
  
  @override
  Future<void> deleteTranslation(String id) async {
    try {
      final history = await getHistory();
      history.removeWhere((t) => t.id == id);
      final jsonString = jsonEncode(history.map((t) => t.toJson()).toList());
      await storageService.save(AppConstants.historyKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to delete translation: $e');
    }
  }
  
  @override
  Future<void> clearHistory() async {
    try {
      await storageService.delete(AppConstants.historyKey);
    } catch (e) {
      throw CacheException('Failed to clear history: $e');
    }
  }
}


