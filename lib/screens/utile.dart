import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ServiceMethods {
  localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  localFile(String fileName) async {
    final path = await localPath();
    return File('$path/$fileName');
  }
}
