


import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:tree_view/tree_view.dart';

class TreeList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TreeView(
      parentList: [
        Parent(
          parent: _folder('root', 5),
          childList: ChildList(
            children: _structure(),
          ),
        ),
      ],
    );
  }

  List<Widget> _structure() {
    List list = ServerFolder.getList();

    List<Widget> result = [];
    for (ServerFolder folder in list) {

      List<Widget> servers = [];
      for (Server server in folder.servers) {
        servers.add(_server(server.title, 25));
      }

      result.add(Parent(
        parent: _folder(folder.title, 15.0),
        childList: ChildList(children: servers,),
      ));
    }
    return result;
  }

  Widget _folder(String title, double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        children: [
          Icon(Icons.folder),
          Text(title),
        ],
      ),
    );
  }

  Widget _server(String title, double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        children: [
          Icon(Icons.computer),
          Text(title),
        ],
      ),
    );
  }
}
