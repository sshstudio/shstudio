

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh_plugin/ssh_plugin.dart';
import 'package:sshstudio/models/server.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class SshTerminal extends StatefulWidget {
  final String terminalId;
  final Server server;

  SshTerminal(this.server, this.terminalId){}

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

  Future<void> connect() async {
    client = new SSHClient(
      host: server.url,
      port: server.port,
      username: server.login,
      passwordOrKey: server.key == null ? server.password :{
        "privateKey": server.getKeyOrPassword(),
      },
    );

    try {
      String result = await client.connect();
      if (result == "session_connected") {
        server.connection = client;
        result = await client.startShell(
            ptyType: "vt100",
            callback: (dynamic res) {
              terminal.write(res);
            });
      }
    } on PlatformException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.message}');
    }
  }

  void onInput(String input) {
    client.writeToShell(input).then((value) {print('result'); print(value);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:

        TerminalView(
          terminal: terminal,
          onResize: (width, height) {
            // client?.setTerminalWindowSize(width, height);
          },
        ),
      ),
    );
  }
}