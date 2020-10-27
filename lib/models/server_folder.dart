import 'package:sshstudio/models/server.dart';

class ServerFolder {
  String title;
  List<Server> servers;

  ServerFolder();

  factory ServerFolder.demo() {
    var folder = ServerFolder();
    folder.title = 'Test';
    folder.servers = [
      new Server(1, 'Very long name of super server', 'ya.ru', 'ya', 'ru'),
      new Server(2, 's2', 'ya.ru', 'ya', 'ru'),
    ];
    return folder;
  }

  static List<ServerFolder> getList() {
    return getDemo();
  }

  static List<ServerFolder> getDemo() {
    return [
      ServerFolder.demo(),
      ServerFolder.demo(),
    ];
  }
}