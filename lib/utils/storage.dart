import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sshstudio/models/server_folder.dart';

const PREFS_KEY_LAST_SYNC_TIME = 'last_sync_time';

class Storage {
  static Future<Directory> getSettingsDir() {
    return getApplicationDocumentsDirectory();
  }

  static Future<List<ServerFolder>> getServers() {
    return getServersFile().then((filename){
      return readFile(filename).then((value) =>
          ServerFolder.fromJson(jsonDecode(value)));
    });
  }

  static Future<String> readFile(String filename, {crypt = true}) {
    File fd = File(filename);
    return fd.exists().then((exist) async {
      return fd.readAsStringSync();
    });
  }

  static Future<List<ServerFolder>> saveServers(String servers) {
    return getServersFile().then((filename) {
      saveToFile(filename, servers);

      SharedPreferences.getInstance().then((prefs){
        prefs.setInt(PREFS_KEY_LAST_SYNC_TIME, DateTime.now().millisecondsSinceEpoch);
      });

      return ServerFolder.fromJson(jsonDecode(servers));
    });
  }

  static String saveToFile(String filename, String content, {crypt = true}) {
    File fd = File(filename);
    fd.writeAsStringSync(content, flush: true);

    return content;
  }

  static Future<String> getServersFile() {
    return getApplicationSupportDirectory().then((dirName) {
      return dirName.path + Platform.pathSeparator + 'pservers.json';
    });
  }
}
