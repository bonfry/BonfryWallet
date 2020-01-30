import 'package:permission_handler/permission_handler.dart';

Future<void> getExternalIOPermission() async{
  Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  var request = true;

  switch (permissions[PermissionGroup.storage]) {
    case PermissionStatus.granted:
      request = true;
      break;
    case PermissionStatus.denied:
      request = false;
      break;
    default:
  }

  print('Statuts ${permissions[PermissionGroup.storage]} | $request');
}
