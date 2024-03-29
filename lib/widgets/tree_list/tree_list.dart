import 'package:flutter/material.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/widgets/tree_list/server_folder_item.dart';

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
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: foldersList,
    );
  }
}
