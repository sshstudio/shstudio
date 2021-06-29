import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/data_access.dart';
import 'package:sshstudio/widgets/modal/add_folder_window.dart';
import 'package:sshstudio/widgets/modal/server_form_window.dart';
import 'package:sshstudio/widgets/tree_list/server_item.dart';

class ServerFolderItem extends StatefulWidget {
  final double padding;
  final ServerFolder folder;
  final bool isRoot;

  ServerFolderItem({this.padding, this.folder, this.isRoot});

  @override
  _ServerFolderItemState createState() => _ServerFolderItemState();
}

class _ServerFolderItemState extends State<ServerFolderItem> {

  bool collapsed = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.padding),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => {
                this.setState(() {
                  this.collapsed = !this.collapsed;
                })
              }, icon:
              Icon(collapsed ? Icons.folder : Icons.folder_open, color: darkBlue)
              ),
              Text(widget.folder.title),
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    widget.isRoot
                        ? null
                        : PopupMenuItem<String>(
                            value: 'remove ' + widget.folder.title,
                            child: GestureDetector(
                                onTap: () {
                                  ServerFolder.structure.removeWhere(
                                      (element) => element.id == widget.folder.id);
                                  ServerFolder.save(ServerFolder.structure);
                                  DataAccess.of(context).updateList();
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.restore_from_trash),
                                    Text('remove'),
                                  ],
                                )),
                          ),
                    widget.isRoot
                        ? PopupMenuItem<String>(
                            value: 'add folder to ' + widget.folder.title,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
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
                    widget.isRoot
                        ? null
                        : PopupMenuItem<String>(
                            value: 'add server to ' + widget.folder.title,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ServerFormWindow(
                                            ServerDto.empty(), widget.folder.id);
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
          _servers()
        ],
      ),
    );
  }

  Widget _servers() {
    return collapsed ? Container() : Column(
        children: widget.folder.servers
            .map((e) => ServerItem(server: e, padding: 15, folderId: widget.folder.id))
            .toList());
  }
}
