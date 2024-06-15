import 'package:permission_handler/permission_handler.dart';

//request storage permission internally from user application
Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}
