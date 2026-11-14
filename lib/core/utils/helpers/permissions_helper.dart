import '../../services/permission_service.dart';
import '../../error/exceptions.dart';

class PermissionsHelper {
  final PermissionService permissionService;
  
  PermissionsHelper(this.permissionService);
  
  Future<bool> ensureCameraPermission() async {
    final hasPermission = await permissionService.hasPermission(PermissionType.camera);
    if (hasPermission) {
      return true;
    }
    
    final granted = await permissionService.requestPermission(PermissionType.camera);
    if (!granted) {
      throw PermissionException('Camera permission denied');
    }
    
    return true;
  }
}


