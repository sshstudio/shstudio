import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/main.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/add_folder_window.dart';
import 'package:sshstudio/widgets/add_server_window.dart';
import 'package:sshstudio/widgets/tree_view.dart';
import 'package:sshstudio/widgets/update_server_window.dart';

class TreeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TreeListState();
  }
}

class _TreeListState extends State<TreeList> {
  List<Widget> structure;

  _TreeListState() {
    _fetchData();
  }

  void _fetchData() {
    _structure().then((val) => setState(() {
      structure = val;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return TreeView(
      hasScrollBar: true,
      parentList: [
        Parent(
          parent: _folder(ServerFolder.root(), 5, isRoot: true),
          childList: ChildList(
            children: structure,
          ),
        ),
      ],
    );
  }

  Future<List<Widget>> _structure() async {
    return ServerFolder.getList().then((List<ServerFolder> folders) {

      return folders.map((ServerFolder folder) {
        List<Widget> servers = [];
        for (Server server in folder.servers) {
          servers.add(_server(server, 25, folder.id));
        }

        return Parent(
          callback: (isSelected) {
            print('tap ' + folder.title);
          },
          parent: _folder(folder, 15.0),
          childList: ChildList(
            children: servers,
          ),
        );
      }).toList();
    });
  }

  Widget _folder(ServerFolder folder, double padding, {isRoot = false}) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        children: [
          Icon(Icons.folder, color: darkBlue),
          Text(folder.title),

          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                isRoot ? null : PopupMenuItem<String>(
                  value: 'remove ' + folder.title,
                  child: GestureDetector(
                      onTap: () {
                        print('remove ' + folder.title);

                        ServerFolder.structure.removeWhere((element) => element.id == folder.id);
                        ServerFolder.save(ServerFolder.structure);

                        _fetchData();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.restore_from_trash),
                          Text('remove'),
                        ],
                      )),
                ),
                isRoot ? PopupMenuItem<String>(
                  value: 'add folder to ' + folder.title,
                  child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddFolderWindow();
                            });

                      },
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text('add folder'),
                        ],
                      )),
                ) : null,
                isRoot ? null : PopupMenuItem<String>(
                  value: 'add server to ' + folder.title,
                  child: GestureDetector(
                      onTap: () {

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddServerWindow(folder.id, _fetchData);
                            });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text('add server'),
                        ],
                      )),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget _server(Server server, double padding, String folderId) {
    return MouseRegion(
      cursor: SystemMouseCursors.contextMenu,
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Row(
          children: [
            Icon(Icons.computer, color: lightBlue),
            GestureDetector(
              onTap: () {
                connectionsPool.openConnection(server);
              },
              child: Text(server.title),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'remove ' + server.title,
                    child: GestureDetector(
                        onTap: () {
                          var struct = ServerFolder.structure;
                          for (ServerFolder currentFolder in struct) {
                            print(currentFolder.title);
                            var servers = currentFolder.servers;
                            servers.removeWhere((element) => element.id == server.id);
                            currentFolder.servers = servers;
                          }
                          ServerFolder.save(struct);
                          _fetchData();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.restore_from_trash),
                            Text('remove'),
                          ],
                        )),
                  ),
                  PopupMenuItem(
                    value: 'edit ' + server.title,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UpdateServerWindow(server, folderId, _fetchData);
                            });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  )
                ];
              },
            )
          ],
        ),
      ),
    );
  }
}
