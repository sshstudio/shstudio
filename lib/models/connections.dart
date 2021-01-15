import 'package:rxdart/rxdart.dart';
import 'package:sshstudio/main.dart';
import 'package:sshstudio/models/server.dart';

class ConnectionsListener {
  BehaviorSubject<Connections> onChange;

  ConnectionsListener(Connections connections)
      : this.onChange = BehaviorSubject<Connections>.seeded(connections);
}

class Connections {

  Map<String, Server> connections = {};

  bool openConnection(Server server) {
    if (false == connections.containsKey(server.id)) {
      connections[server.id] = server;
      connectionsListener.onChange.value = this;
      return true;
    }
    return false;
  }

  void closeConnection(String id) {
    if (connections[id].connection != null) {
      connections[id].connection.disconnect('user event');
    }
    connections.remove(id);
    connectionsListener.onChange.value = this;
  }
}