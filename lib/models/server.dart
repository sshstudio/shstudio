import 'dart:io';

import 'package:dartssh/client.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/models/snippet.dart';

class ServerDto {
  String id;
  String title;
  String url;
  String login;
  String password;

  int port = 22;

  String key;

  ServerDto(
      {this.id,
      this.title,
      this.url,
      this.login,
      this.password,
      port = 22,
      this.key});

  factory ServerDto.fromServer(Server server) {
    return ServerDto(
        id: server.id,
        title: server.title,
        url: server.url,
        login: server.login,
        password: server.password,
        port: server.port,
        key: server.key);
  }
}

class Server {
  String id;
  String title;
  String url;
  String login;
  String password;

  int port = 22;

  String key;

  List<Snippet> snippets = [];

  String getKeyOrPassword() {
    if (key != null) {
      File file = File(key);
      return file.readAsStringSync();
    }

    return password;
  }

  String getKey() {
    if (key == null || key.isEmpty || key == '') {
      return null;
    }
    return key;
  }

  SSHClient connection;

  Server(this.id, this.title, this.url, this.login, this.password,
      {this.port = 22, this.key, this.snippets});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'login': login,
        'password': password,
        'port': port,
        'key': key,
        'snippets' : snippets
      };

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
        json['id'], json['title'], json['url'], json['login'], json['password'],
        port: json['port'], key: json['key'], snippets: json['snippets']);
  }

  void saveToFolder(String folderId) {
    for (final folder in ServerFolder.structure) {
      if (folder.id == folderId) {
        folder.servers.removeWhere((element) => element.id == this.id);
        folder.servers.add(this);
        ServerFolder.save(ServerFolder.structure);
        break;
      }
    }
  }
}
