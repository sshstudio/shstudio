import 'package:rxdart/rxdart.dart';
import 'package:sshstudio/main.dart';
import 'package:sshstudio/models/server_folder.dart';

class Snippet {
  String id;
  String serverId;
  String title;
  String command;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'command': command,
  };

  Snippet(this.id, this.title, this.command);

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(json['id'], json['title'], json['command']);
  }

  void save() {
    for (final folder in ServerFolder.structure) {
      for (final server in folder.servers) {
        if (server.id == serverId) {
          if (server.snippets is List) {
            server.snippets.removeWhere((element) => element.id == this.id);
            server.snippets.add(this);
          } else {
            server.snippets = [
              this
            ];
          }
          ServerFolder.save(ServerFolder.structure);
        }
      }
    }
  }

  Future<List<ServerFolder>> delete() {
    for (final folder in ServerFolder.structure) {
      for (final server in folder.servers) {
        if (server.id == serverId) {
          if (server.snippets is List) {
            server.snippets.removeWhere((element) => element.id == this.id);
          }
        }
      }
    }
    return ServerFolder.save(ServerFolder.structure);
  }
}

class SnippetsListener {
  BehaviorSubject<SnippetsList> onChange;

  SnippetsListener(SnippetsList events)
      : this.onChange = BehaviorSubject<SnippetsList>.seeded(events);
}

class SnippetsList {
  bool _inc = false;
  void update() {
    _inc = !_inc;
    snippetsListener.onChange.value = this;
  }
  
}