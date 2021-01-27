import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/snippet.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/modal/snippet_form_window.dart';

import '../../main.dart';

class SnippetsDrawer extends StatelessWidget {
  const SnippetsDrawer({
    Key key,
  }) : super(key: key);

  void onUpdate() {
    snippetsList.update();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectionsListener.onChange,
        builder: (context, connectionsSnapshot) {
          return connectionsSnapshot.data == null
              ? Container()
              : connectionsSnapshot.data.activeConnection.id != ''
                  ? StreamBuilder(
                    stream: snippetsListener.onChange,
                    builder: (context, snapshot) {
                      return Drawer(
                          child: ListView(
                            // Important: Remove any padding from the ListView.
                            padding: EdgeInsets.zero,
                            children: _drawerContent(context, connectionsSnapshot.data.activeConnection),
                          ),
                        );
                    }
                  )
                  : Container();
        });
  }

  List<Widget> _drawerContent(context, Server server) {
    Server connection = connectionsPool.activeConnection;
    List<Widget> list = [
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text('Snippets for ' + connection.title),
           IconButton(
             icon: Icon(Icons.add),
             onPressed: () {
               showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return SnippetFormWindow(server.id, onUpdate);
                   });
             },
           )
         ],
       )
    ];

    if (connection.snippets is List) {
      connection.snippets.forEach((element) {
        list.add(_snippetItem(element, server));
      });
    }
    return list;
  }

  Widget _snippetItem(Snippet snippet, Server server) {
    return ListTile(
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Icon(Icons.computer, color: lightBlue),
              Text(
                snippet.title,
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'edit ' + snippet.title,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SnippetFormWindow(server.id, onUpdate, snippet: snippet);
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
                      value: 'remove ' + snippet.title,
                      child: GestureDetector(
                          onTap: () {
                            print('remove ' + snippet.title);
                            snippet.delete();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.restore_from_trash),
                              Text('remove'),
                            ],
                          )
                      ),
                    ),
                  ];
                },
              )
            ],
          ),
        ),
      ),
      onTap: () {
        server.client?.sendChannelData(utf8.encode(snippet.command+'\n'));
      },
    );
  }
}
