
import 'package:flutter/material.dart';

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

        return snapshot.data == null ? Container() : snapshot.data.activeConnection.id != '' ?

         Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Snippets for ' + snapshot.data.activeConnection.title),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ) : Container();
      }
    );
  }
}