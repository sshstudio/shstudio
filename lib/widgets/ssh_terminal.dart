import 'dart:convert';
import 'dart:io';

import 'package:dartssh/client.dart';
import 'package:dartssh/identity.dart';
import 'package:dartssh/pem.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/keyboard_listener.dart' as kbl;
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class SshTerminal extends StatefulWidget {
  final Server server;

  SshTerminal(this.server);

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
    terminal = Terminal(theme: _terminalTheme, maxLines: 80);
    connect();
  }

  void connect() {

    var key = server.getKey();

    terminal.write('connecting ${server.url}...\n');
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
        terminal.write('connected.\n\n');
      },
      disconnected: () {
        terminal.write('\ndisconnected.');
      },
      loadIdentity: key == null ? null: () {
        if (identity == null && server.key != null) {
          identity = parsePem(File(server.key).readAsStringSync());
        }
        return identity;
      },
    );

    server.terminal = terminal;
    server.client = client;
  }

  void onInput(String input) {
    client?.sendChannelData(utf8.encode(input));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(_terminalTheme.background),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  kbl.KeyboardListener(
              terminal: terminal,
              textController: TextEditingController(),
                child: TerminalView(
                  terminal: terminal,
                  autofocus: true,
                )
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
