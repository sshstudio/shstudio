import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/widgets/tree_list/server_folder_item.dart';
import 'package:sshstudio/widgets/tree_list/server_item.dart';

import '../data_access.dart';

class TreeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var folders = StateContainer.of(context).state.servers;

    List<Widget> foldersList = [];

    foldersList.add(ServerFolderItem(
        padding: 5, folder: ServerFolder.root(), isRoot: true));
    for (ServerFolder folder in folders) {
      foldersList
          .add(ServerFolderItem(padding: 15, folder: folder, isRoot: false));
      for (Server server in folder.servers) {
        foldersList
            .add(ServerItem(server: server, padding: 30, folderId: folder.id));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: foldersList,
    );
  }
}
