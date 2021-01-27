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
}