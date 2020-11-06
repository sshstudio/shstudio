import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sshstudio/models/server_folder.dart';

class Storage {
  static Future<Directory> getSettingsDir() {
    return getApplicationDocumentsDirectory();
  }

  static Future<List<ServerFolder>> getServers() {
    return getApplicationSupportDirectory().then((dirName) {
      var file = dirName.path + Platform.pathSeparator + 'servers.json';
      File fd = File(file);
      return fd.exists().then((exist) async {
        String content = await fd.readAsString();
        return ServerFolder.fromJson(jsonDecode(content));
      });
    });
  }

  static Future<List<ServerFolder>> saveServers(String servers) {
    return getApplicationSupportDirectory().then((dirName) {
      var file = dirName.path + Platform.pathSeparator + 'servers.json';
      File fd = File(file);
      return fd.exists().then((exist) async {
        fd.writeAsString(servers);
        String content = await fd.readAsString();
        return ServerFolder.fromJson(jsonDecode(content));
      });
    });
  }
}
