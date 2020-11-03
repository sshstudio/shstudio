import 'dart:io';

import 'package:ssh_plugin/ssh_plugin.dart';

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

  Server(this.id, this.title, this.url, this.login, this.password);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'login': login,
        'password': password
      };

  Server.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        url = json['url'],
        login = json['login'],
        password = json['password'],
        key = json['key'];
}
