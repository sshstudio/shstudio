import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/modal/server_form_window.dart';

import '../../main.dart';

class ServerItem extends StatelessWidget {
  final Server server;
  final double padding;
  final String folderId;
  final Function onUpdate;
  final bool active;

  ServerItem(
      {this.server,
      this.padding,
      this.folderId,
      this.onUpdate,
      this.active = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectionsListener.onChange,
        builder: (context, snapshot) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: EdgeInsets.only(left: padding),
              child: Row(
                children: [
                  Icon(Icons.computer, color: lightBlue),
                  GestureDetector(
                    onTap: () {
                      _onServerTap(server, context);
                    },
                    child: Text(
                      server.title,
                      style: TextStyle(
                          color: snapshot.data != null ? snapshot.data.activeConnection.id == server.id
                              ? Colors.lightBlue
                              : Colors.black: Colors.black),
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'edit ' + server.title,
                          child: GestureDetector(
                            onTap: () {
                              _onServerTap(server, context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.cast_connected),
                                Text('Connect'),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit ' + server.title,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ServerFormWindow(
                                        ServerDto.fromServer(server),
                                        folderId,
                                        onUpdate);
                                  });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'remove ' + server.title,
                          child: GestureDetector(
                              onTap: () {
                                var struct = ServerFolder.structure;
                                for (ServerFolder currentFolder in struct) {
                                  print(currentFolder.title);
                                  var servers = currentFolder.servers;
                                  servers.removeWhere(
                                      (element) => element.id == server.id);
                                  currentFolder.servers = servers;
                                }
                                ServerFolder.save(struct);
                                onUpdate();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.restore_from_trash),
                                  Text('remove'),
                                ],
                              )),
                        ),
                      ];
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void _onServerTap(Server server, BuildContext context) {
    // connectionsPool.setActiveConnection(server);
    if (false == connectionsPool.openConnection(server)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Соединение для сервера ' + server.title + ' уже открыто'),
        ),
      );
    }
  }
}
