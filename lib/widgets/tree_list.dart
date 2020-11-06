import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/main.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/widgets/add_folder_window.dart';
import 'package:sshstudio/widgets/add_server_window.dart';
import 'package:sshstudio/widgets/tree_view.dart';

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
          servers.add(_server(server, 25));
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
          Icon(Icons.folder, color: Color.fromRGBO(17, 63, 134, 1)),
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
                      child: Text('remove')),
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
                      child: Text('add folder')),
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
                      child: Text('add server')),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Widget _server(Server server, double padding) {
    return MouseRegion(
      cursor: SystemMouseCursors.contextMenu,
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Row(
          children: [
            Icon(Icons.computer, color: Color.fromRGBO(35, 147, 239, 1)),
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
                        child: Text('remove')),
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
