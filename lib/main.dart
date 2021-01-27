import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry/sentry.dart';
import 'package:sshstudio/models/connections.dart';
import 'package:sshstudio/models/snippet.dart';
import 'package:sshstudio/screen/main_screen.dart';

Connections connectionsPool = Connections();
final ConnectionsListener connectionsListener  = ConnectionsListener(connectionsPool);

SnippetsList snippetsList = SnippetsList();
final SnippetsListener snippetsListener = SnippetsListener(snippetsList);

Future<void> main() async {

  await DotEnv().load('.env');
  final sentry = SentryClient(dsn: DotEnv().env['SENTRY_DSN']);

  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stackTrace) async {
      await sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ssh Studio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(), // MyHomePage(),
    );
  }
}
