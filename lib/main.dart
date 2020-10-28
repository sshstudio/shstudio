import 'dart:async';
import 'dart:convert';

import 'package:dartssh/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry/sentry.dart';
import 'package:sshstudio/screen/main_screen.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

const host = 'ssh://localhost:22';
const username = 'test';
const password = 'test';

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
      title: 'xterm.dart demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(), // MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Terminal terminal;
  SSHClient client;

  @override
  void initState() {
    super.initState();
    terminal = Terminal(onInput: onInput);
    connect();
  }

  void connect() {
    terminal.write('connecting $host...');
    client = SSHClient(
      hostport: Uri.parse(host),
      login: username,
      print: print,
      termWidth: 80,
      termHeight: 25,
      termvar: 'xterm-256color',
      getPassword: () => utf8.encode(password),
      response: (transport, data) {
        terminal.write(data);
      },
      success: () {
        terminal.write('connected.\n');
      },
      disconnected: () {
        terminal.write('disconnected.');
      },
    );
  }

  void onInput(String input) {
    client?.sendChannelData(utf8.encode(input));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TerminalView(
          terminal: terminal,
          onResize: (width, height) {
            client?.setTerminalWindowSize(width, height);
          },
        ),
      ),
    );
  }
}
