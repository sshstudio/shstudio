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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectionsListener.onChange,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : snapshot.data.activeConnection.id != ''
                  ? Drawer(
                      child: ListView(
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: _drawerContent(context),
                      ),
                    )
                  : Container();
        });
  }

  List<Widget> _drawerContent(context) {
    Server connection = connectionsPool.activeConnection;
    List<Widget> list = [

       Row(
         children: [
           Text('Snippets for ' + connection.title),
           IconButton(
             icon: Icon(Icons.add),
             onPressed: () {
               print('add sn');

               showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return SnippetFormWindow('serverId', (){});
                   });


             },
           )
         ],
       )
    ];

    if (connection.snippets is List) {
      connection.snippets.forEach((element) {
        list.add(_snippetItem(element));
      });
    }
    return list;
  }

  Widget _snippetItem(Snippet snippet) {
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
                          print('edit ' + snippet.title);
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
                          },
                          child: Row(
                            children: [
                              Icon(Icons.restore_from_trash),
                              Text('remove'),
                            ],
                          )),
                    ),
                  ];
                },
              )
            ],
          ),
        ),
      ),
      onTap: () {
        // Update the state of the app.
        // ...
        print('tap ' + snippet.title);
      },
    );
  }
}
