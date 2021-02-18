import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sshstudio/services/s3.dart';
import 'package:sshstudio/services/sync.dart';
import 'package:sshstudio/widgets/data_access.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences prefs;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => setState(() => {prefs = value}));
  }

  sync(BuildContext context) async {
    var service = new Sync(StateContainer.of(context).state.servers);
    service.process();
  }

  @override
  Widget build(BuildContext context) {
    return prefs == null ? Container() : Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Container(
                width: 300,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Text('s3 key'),
                      TextFormField(
                        initialValue: prefs.getString(PREFS_KEY_S3_KEY),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Folder name cant be blank';
                          }
                          prefs.setString(PREFS_KEY_S3_KEY, value);
                          return null;
                        },
                      )
                    ]),
                    TableRow(children: [
                      Text('s3 secret'),
                      TextFormField(
                        initialValue: prefs.getString(PREFS_KEY_S3_SECRET),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Folder name cant be blank';
                          }
                          prefs.setString(PREFS_KEY_S3_SECRET, value);
                          return null;
                        },
                      )
                    ]),
                    TableRow(children: [
                      Text('s3 bucket'),
                      TextFormField(
                        initialValue: prefs.getString(PREFS_KEY_S3_BUCKET),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Folder name cant be blank';
                          }
                          prefs.setString(PREFS_KEY_S3_BUCKET, value);
                          return null;
                        },
                      )
                    ]),
                    TableRow(children: [
                      Text('s3 region'),
                      TextFormField(
                        initialValue: prefs.getString(PREFS_KEY_S3_REGION),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Folder name cant be blank';
                          }
                          prefs.setString(PREFS_KEY_S3_REGION, value);
                          return null;
                        },
                      )
                    ]),
                    TableRow(children: [
                      Text('s3 host'),
                      TextFormField(
                        initialValue: prefs.getString(PREFS_KEY_S3_HOST),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Folder name cant be blank';
                          }
                          prefs.setString(PREFS_KEY_S3_HOST, value);
                          return null;
                        },
                      )
                    ]),
                    TableRow(children: [
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.save), Text('save')],
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.refresh), Text('sync')],
                        ),
                        onPressed: () => sync(context),
                      ),
                    ])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
