
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:uuid/uuid.dart';

class _FormData {
  String id;
  String title;
  String url;
  String login;
  String password;
  int port = 22;
  String key;
}

class AddServerWindow extends StatelessWidget {
  final String folderId;

  final onSuccess;

  AddServerWindow(this.folderId, this.onSuccess);

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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'New server name',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder name cant be blank';
                      }
                      data.title = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'New server url',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder name cant be blank';
                      }
                      data.url = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: '22',
                    decoration: InputDecoration(
                      hintText: 'New server port',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Port cant be blank';
                      }
                      data.port = int.parse(value);
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'New server login',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder name cant be blank';
                      }
                      data.login = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'New server password',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder name cant be blank';
                      }
                      data.password = value;
                      return null;
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: () =>
                  {
                    showOpenPanel(
                        canSelectDirectories: false,
                        allowsMultipleSelection: false)
                        .then((FileChooserResult value) =>
                    data.key = value.paths[0])
                  },
                  child: Text("Open file picker"),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Add"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Server(
                                (new Uuid()).v4(),
                                data.title,
                                data.url,
                                data.login,
                                data.password,
                              key: data.key,
                              port: data.port
                            )
                              ..saveToFolder(folderId);

                            onSuccess();

                            Navigator.of(context).pop();
                          }
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
