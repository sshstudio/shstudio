
class Server {
  int id;
  String title;
  String url;
  String login;
  String password;

  Server(this.id, this.title, this.url, this.login, this.password);

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'url': url,
        'login': login,
        'passoerd': password
      };

  Server.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        url = json['url'],
        login = json['login'],
        password = json['password']
  ;
}