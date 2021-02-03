import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/data_access.dart';
import 'package:sshstudio/widgets/modal/add_folder_window.dart';
import 'package:sshstudio/widgets/modal/server_form_window.dart';

class ServerFolderItem extends StatelessWidget {
  final double padding;
  final ServerFolder folder;
  final bool isRoot;

  ServerFolderItem({this.padding, this.folder, this.isRoot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        children: [
          Icon(Icons.folder, color: darkBlue),
          Text(folder.title),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                isRoot
                    ? null
                    : PopupMenuItem<String>(
                        value: 'remove ' + folder.title,
                        child: GestureDetector(
                            onTap: () {
                              ServerFolder.structure.removeWhere(
                                  (element) => element.id == folder.id);
                              ServerFolder.save(ServerFolder.structure);
                              DataAccess.of(context).updateList();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.restore_from_trash),
                                Text('remove'),
                              ],
                            )),
                      ),
                isRoot
                    ? PopupMenuItem<String>(
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
                      )
                    : null,
                isRoot
                    ? null
                    : PopupMenuItem<String>(
                        value: 'add server to ' + folder.title,
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ServerFormWindow(
                                        ServerDto(), folder.id);
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
}
