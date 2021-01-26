import 'package:flutter/material.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:uuid/uuid.dart';

class _FormData {
  String name;
}

class AddFolderWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    var data = _FormData();

    return AlertDialog(
      content: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [Text('Add folder')],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'New folder name',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder name cant be blank';
                      }
                      data.name = value;
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Add"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            var folder = ServerFolder();
                            folder.title = data.name;
                            folder.id = (Uuid()).v4();
                            ServerFolder.structure.add(folder);
                            ServerFolder.save(ServerFolder.structure);

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // if (_formKey.currentState.validate()) {
                          //   _formKey.currentState.save();
                          // }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
