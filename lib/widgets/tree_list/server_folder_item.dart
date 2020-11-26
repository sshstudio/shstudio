import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/modal/add_folder_window.dart';

import '../modal/add_server_window.dart';

class ServerFolderItem extends StatelessWidget {

  final double padding;
  final ServerFolder folder;
  final bool isRoot;
  final Function onUpdate;


  ServerFolderItem({this.padding, this.folder, this.isRoot, this.onUpdate});

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
                isRoot ? null : PopupMenuItem<String>(
                  value: 'remove ' + folder.title,
                  child: GestureDetector(
                      onTap: () {
                        print('remove ' + folder.title);

                        ServerFolder.structure.removeWhere((element) => element.id == folder.id);
                        ServerFolder.save(ServerFolder.structure);

                        onUpdate();
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
                              return AddServerWindow(folder.id, onUpdate);
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