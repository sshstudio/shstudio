import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PREFS_KEY_S3_KEY = 's3key';
const PREFS_KEY_S3_SECRET = 's3secret';
const PREFS_KEY_S3_BUCKET = 's3bucket';
const PREFS_KEY_S3_REGION = 's3region';
const PREFS_KEY_S3_HOST = 's3host';

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
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Text('save'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                          }
                        },
                      ),
                      Container()
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
