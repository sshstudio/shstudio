import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/utils/storage.dart';

class ServerFolder {
  String title;
  List<Server> servers = [];

  ServerFolder();

  factory ServerFolder.root() {
    ServerFolder folder = new ServerFolder();
    folder.title = 'root';
    return folder;
  }

  factory ServerFolder.demo() {
    var folder = ServerFolder();
    folder.title = 'Test';
    folder.servers = [
      new Server(1, 'name of server', 'ya.ru', 'ya', 'ru'),
      new Server(2, 's2', 'ya.ru', 'ya', 'ru'),
    ];
    return folder;
  }

  static List<ServerFolder> fromJson(List<dynamic> json) {
    return json.map((e) {
      List l = e['servers'];
      List<Server> servers = l.map((server) {
        var s = Server.fromJson(server);
        return s;
      }).toList();
      var folder = ServerFolder();
      folder.title = e['title'];
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
      return value == null ? getDemo() : value;
    }).catchError((onError) => getDemo());
  }

  static List<ServerFolder> getDemo() {
    return [
      ServerFolder.demo(),
      ServerFolder.demo(),
    ];
  }
}