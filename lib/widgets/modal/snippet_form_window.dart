
import 'package:flutter/material.dart';
import 'package:sshstudio/models/snippet.dart';
import 'package:uuid/uuid.dart';

class SnippetFormWindow extends StatelessWidget {
  final String serverId;

  final onSuccess;

  Snippet snippet;

  SnippetFormWindow(this.serverId, this.onSuccess, {this.snippet});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    var data = snippet == null ? Snippet((new Uuid()).v4().toString(), null, null) : snippet;
    data.serverId = serverId;

    print(data.title);

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
                    initialValue: data.title,
                    decoration: InputDecoration(
                      hintText: 'Snippet name',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Snippet name cant be blank';
                      }
                      data.title = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: data.command,
                    decoration: InputDecoration(
                      hintText: 'Snippet command',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Snippet command cant be blank';
                      }
                      data.command = value;
                      return null;
                    },
                  ),
                ),



                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text("Save"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {

                            data.save();

                            // Server(
                            //     server.id,
                            //     data.title,
                            //     data.url,
                            //     data.login,
                            //     data.password,
                            //   key: data.key,
                            //   port: data.port
                            // )
                            //   ..saveToFolder(folderId);

                            onSuccess();

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
