import 'dart:convert';
import 'dart:io';

import 'package:dartssh/client.dart';
import 'package:dartssh/identity.dart';
import 'package:dartssh/pem.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class SshTerminal extends StatefulWidget {
  final String terminalId;
  final Server server;

  SshTerminal(this.server, this.terminalId);

  @override
  _SshTerminalState createState() => _SshTerminalState(this.server);
}

class _SshTerminalState extends State<SshTerminal> with AutomaticKeepAliveClientMixin<SshTerminal> {
  Terminal terminal;
  SSHClient client;
  final Server server;

  final _terminalTheme = defaultTheme;

  Identity identity;

  _SshTerminalState(this.server);

  @override
  void initState() {
    super.initState();
    terminal = Terminal(onInput: onInput, theme: _terminalTheme);
    connect();
  }

  void connect() {

    print(server.key);

    var key = server.getKey();

    terminal.write('connecting ${server.url}...');
    client = SSHClient(
      hostport: Uri(host: server.url, port: server.port),
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
      loadIdentity: key == null ? null: () {
        if (identity == null && server.key != null) {
          identity = parsePem(File(server.key).readAsStringSync());
        }
        return identity;
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
        child: Container(
          color: Color(_terminalTheme.background.value),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TerminalView(
              terminal: terminal,
              autofocus: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
