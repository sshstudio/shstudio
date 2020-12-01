
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';

import '../file_select.dart';

class _FormData {
  String id;
  String title;
  String url;
  String login;
  String password;
  int port = 22;
  String key;
}

class UpdateServerWindow extends StatelessWidget {
  final String folderId;

  final onSuccess;

  final Server server;

  UpdateServerWindow(this.server, this.folderId, this.onSuccess);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    var data = _FormData();

    data.key = server.key;

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
                    initialValue: server.title,
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
                    initialValue: server.url,
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
                    initialValue: server.port.toString(),
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
                    initialValue: server.login,
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
                    initialValue: server.password,
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
                FileSelect(
                  width: 130,
                  button: Text('select key'),
                  validator: (value) {
                    if (value.isEmpty || data.password.isEmpty) {
                      return 'Folder name cant be blank';
                    }
                    data.key = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'New server login',
                    filled: true,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Save"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Server(
                                server.id,
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
