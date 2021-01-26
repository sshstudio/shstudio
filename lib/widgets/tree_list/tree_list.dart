import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/widgets/tree_list/server_folder_item.dart';
import 'package:sshstudio/widgets/tree_list/server_item.dart';

class TreeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TreeListState();
  }
}

class _TreeListState extends State<TreeList> {
  List<Widget> structure = [];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: structure,
    );
  }

  Future<List<Widget>> _structure() async {
    return ServerFolder.getList().then((List<ServerFolder> folders) {
      List<Widget> foldersList =  [];
      foldersList.add(ServerFolderItem(padding: 5, folder: ServerFolder.root(), isRoot: true, onUpdate: _fetchData));
      for(ServerFolder folder in folders) {
        foldersList.add(ServerFolderItem(padding: 15, folder: folder, isRoot: false, onUpdate: _fetchData));
        for (Server server in folder.servers) {
          foldersList.add(ServerItem(server: server, padding: 30, folderId: folder.id, onUpdate: _fetchData));
        }
      }

      return foldersList;
    });
  }
}
