import 'package:rxdart/rxdart.dart';
import 'package:sshstudio/main.dart';
import 'package:sshstudio/models/server.dart';
import 'package:uuid/uuid.dart';

class ConnectionsListener {
  BehaviorSubject<Connections> onChange;

  ConnectionsListener(Connections connections)
      : this.onChange = BehaviorSubject<Connections>.seeded(connections);
}

class Connections {

  var uuid = Uuid();

  Map<String, Server> connections = {};

  Future openConnection(Server server) {
    connections[uuid.v4()] = server;
    connectionsListener.onChange.value = this;
  }

  Future closeConnection(String id) {
    connections.remove(id);
    connectionsListener.onChange.value = this;
  }
}