
import 'package:ssh/ssh.dart' as ssh;


class Server {
  int id;
  String title;
  String url;
  String login;
  String password;

  int port = 22;

  String key;

  ssh.SSHClient connection;

  Server(this.id, this.title, this.url, this.login, this.password);

  Map<String, dynamic> toJson() =>
      {
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
        password = json['password']
  ;
}