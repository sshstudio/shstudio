
import 'dart:convert';

import 'package:dartssh/client.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class SshTerminal extends StatefulWidget {
  final Server server;

  SshTerminal(this.server){}

  @override
  _SshTerminalState createState() => _SshTerminalState(this.server);
}

class _SshTerminalState extends State<SshTerminal> {
  Terminal terminal;
  SSHClient client;
  final Server  server;

  _SshTerminalState(this.server);

  @override
  void initState() {
    super.initState();
    terminal = Terminal(onInput: onInput);
    connect();
  }

  void connect() {
    terminal.write('connecting ${server.url}...');
    client = SSHClient(
      hostport: Uri.parse('ssh://'+server.url+':22'),
      login: server.login,
      print: print,
      termWidth: 80,
      termHeight: 25,
      termvar: 'xterm-256color',
      getPassword: () => utf8.encode(server.password),
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