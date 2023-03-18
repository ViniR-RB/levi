import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class DirectoryPath {
  final String directoryName;
  DirectoryPath(this.directoryName);

  Future<io.Directory> createDirectory() async {
    io.Directory directoryBase;

    if (io.Platform.isIOS) {
      directoryBase = await getApplicationDocumentsDirectory();
    } else {
      directoryBase = (await getExternalStorageDirectory())!;
    }

    var fullPath = directoryBase.path + directoryName;

    var appDirectory = io.Directory(fullPath);
    bool existDirectory = await appDirectory.exists();

    if (!existDirectory) {
      appDirectory.create();
    }

    return appDirectory;
  }

  Future<String> getFileName(String fileName) async {
    var directory = await createDirectory();
    var filePath = directory.path + fileName;

    return filePath;
  }
}
