import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> getExternalIOPermission() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  return permissions[PermissionGroup.storage];
}
