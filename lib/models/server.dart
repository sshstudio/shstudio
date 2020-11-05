import 'dart:io';

import 'package:ssh_plugin/ssh_plugin.dart';
import 'package:sshstudio/models/server_folder.dart';

class Server {
  String id;
  String title;
  String url;
  String login;
  String password;

  int port = 22;

  String key;

  String getKeyOrPassword() {
    if (key != null) {
      File file = File(key);
      return file.readAsStringSync();
    }

    return password;
  }

  SSHClient connection;

  Server(this.id, this.title, this.url, this.login, this.password,
      {this.port = 22, this.key});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'login': login,
        'password': password,
        'port': port,
        'key': key,
      };

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(json['id'], json['title'], json['url'], json['login'], json['password'], port: json['port'], key: json['key']);
  }


  void saveToFolder(String folderId) {
    for (final folder in ServerFolder.structure) {
      if(folder.id == folderId) {
        folder.servers.add(this);
        ServerFolder.save(ServerFolder.structure);
        break;
      }
    }
  }
}
