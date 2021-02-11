import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as cr;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sshstudio/models/server_folder.dart';

class Storage {
  static Future<Directory> getSettingsDir() {
    return getApplicationDocumentsDirectory();
  }

  static Future<List<ServerFolder>> getServers() {
    return getApplicationSupportDirectory().then((dirName) {
      print(dirName);
      var file = dirName.path + Platform.pathSeparator + 'servers.json';
      return readFile(file).then((value) => ServerFolder.fromJson(jsonDecode(value)));
    });
  }

  static Future<String> readFile(String filename, {crypt = true}) {
    File fd = File(filename);
    return fd.exists().then((exist) async {
      String content = await fd.readAsString();
      if (kReleaseMode) {
        content = decrypt(content);
      }
      return content;
    });
  }

  static Future<List<ServerFolder>> saveServers(String servers) {
    return getApplicationSupportDirectory().then((dirName) {
      var file = dirName.path + Platform.pathSeparator + 'servers.json';
      saveToFile(file, servers);
      return ServerFolder.fromJson(jsonDecode(servers));
    });
  }

  static Future<String> saveToFile(String filename, String content, {crypt = true}) {
    File fd = File(filename);
    return fd.exists().then((exist) async {

      if (kReleaseMode && crypt) {
        content = crypt(content);
      }

      fd.writeAsString(content);
      return content;
    });
  }

  static String crypt(String data)
  {
    return data;
    final key = cr.Key.fromLength(32);
    final iv = cr.IV.fromLength(16);
    final encrypter = cr.Encrypter(cr.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return encrypted.base16;
  }

  static String decrypt(String data)
  {
    return data;
    final key = cr.Key.fromLength(32);
    final iv = cr.IV.fromLength(16);
    final encrypter = cr.Encrypter(cr.AES(key));

    final decrypted = encrypter.decrypt16(data, iv: iv);
    return decrypted;
  }
}
