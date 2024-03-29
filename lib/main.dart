import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry/sentry.dart';
import 'package:sshstudio/models/connections.dart';
import 'package:sshstudio/models/snippet.dart';
import 'package:sshstudio/screen/desktop/main_screen.dart';
import 'package:sshstudio/screen/mobile/main_screen.dart';
import 'package:sshstudio/widgets/data_access.dart';

Connections connectionsPool = Connections();
final ConnectionsListener connectionsListener  = ConnectionsListener(connectionsPool);

SnippetsList snippetsList = SnippetsList();
final SnippetsListener snippetsListener = SnippetsListener(snippetsList);

bool isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
bool isMobile = false == isDesktop;

Future<void> main() async {

  await dotenv.load(fileName: ".env");

  await Sentry.init(
        (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataAccess(
      child: MaterialApp(
        title: 'Ssh Studio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: isDesktop ? MainScreenDesktop() : MainScreenMobile(), // MyHomePage(),
      ),
    );
  }
}
