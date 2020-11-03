import 'dart:convert';

import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/utils/storage.dart';
import 'package:uuid/uuid.dart';



class ServerFolder {
  String id;
  String title;
  List<Server> servers = [];


  ServerFolder();

  static List<ServerFolder> structure = [];

  factory ServerFolder.root() {
    ServerFolder folder = new ServerFolder();
    folder.title = 'root';
    return folder;
  }

  static List<ServerFolder> fromJson(List<dynamic> json) {
    var uuid = Uuid();
    return json.map((e) {
      List l = e['servers'];
      List<Server> servers = l.map((server) {
        var s = Server.fromJson(server);
        return s;
      }).toList();
      var folder = ServerFolder();
      folder.title = e['title'];
      folder.id = e['id'] == null ? uuid.v4().toString() : e['id'];
      folder.servers = servers;
      return folder;
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'servers': servers,
      };

  static Future<List<ServerFolder>> getList() {
    return Storage.getServers().then((List<ServerFolder> value) {
      structure = value == null ? getDemo() : value;
      return structure;
    }).catchError((onError) => getDemo());
  }

  static List<ServerFolder> getDemo() {
    return [];
  }

  static Future<List<ServerFolder>> save(List<ServerFolder> list) {
    return Storage.saveServers(jsonEncode(list)).then((List<ServerFolder> value) {
      structure = value == null ? getDemo() : value;
      return structure;
    }).catchError((onError) => getDemo());
  }
}