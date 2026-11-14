import 'package:permission_handler/permission_handler.dart';
import '../error/exceptions.dart';

enum PermissionType {
  camera,
  storage,
}

abstract class PermissionService {
  Future<bool> requestPermission(PermissionType type);
  Future<bool> hasPermission(PermissionType type);
  Future<bool> shouldShowRequestRationale(PermissionType type);
}

class PermissionServiceImpl implements PermissionService {
  Permission _getPermission(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.storage:
        return Permission.storage;
    }
  }
  
  @override
  Future<bool> requestPermission(PermissionType type) async {
    try {
      final permission = _getPermission(type);
      final status = await permission.request();
      return status.isGranted;
    } catch (e) {
      throw PermissionException('Failed to request permission: $e');
    }
  }
  
  @override
  Future<bool> hasPermission(PermissionType type) async {
    try {
      final permission = _getPermission(type);
      final status = await permission.status;
      return status.isGranted;
    } catch (e) {
      throw PermissionException('Failed to check permission: $e');
    }
  }
  
  @override
  Future<bool> shouldShowRequestRationale(PermissionType type) async {
    try {
      final permission = _getPermission(type);
      final status = await permission.status;
      return status.isDenied || status.isLimited;
    } catch (e) {
      throw PermissionException('Failed to check rationale: $e');
    }
  }
}


