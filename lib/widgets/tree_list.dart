import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:tree_view/tree_view.dart';

class TreeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TreeListState();
  }
}

class _TreeListState extends State<TreeList> {
  List<Widget> structure;

  _TreeListState() {
    _structure().then((val) => setState(() {
          structure = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return TreeView(
      parentList: [
        Parent(
          parent: IconButton(
            color: Colors.green,
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _addWindow(context);
                  });
            },
          ),
          childList: ChildList(),
        ),
        Parent(
          parent: _folder('root', 5),
          childList: ChildList(
            children: structure,
          ),
        ),
      ],
    );
  }

  Future<List<Widget>> _structure() async {
    return ServerFolder.getList().then((List<ServerFolder> folders) {
      return folders.map((ServerFolder folder) {
        List<Widget> servers = [];
        for (Server server in folder.servers) {
          servers.add(_server(server.title, 25));
        }

        return Parent(
          parent: _folder(folder.title, 15.0),
          childList: ChildList(
            children: servers,
          ),
        );
      }).toList();
    });
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
    return MouseRegion(
      cursor: SystemMouseCursors.contextMenu,
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Row(
          children: [
            Icon(Icons.computer),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _addWindow(context) {
    return AlertDialog(
      content: Stack(
        children: <Widget>[
          Form(
            // key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();
                      // }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();
                      // }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
