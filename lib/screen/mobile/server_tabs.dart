import 'package:flutter/material.dart';
import 'package:sshstudio/widgets/drawer/snippets.dart';
import 'package:sshstudio/widgets/tabbed_area.dart';

class ServerTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ServerTabsState();
  }
}

class _ServerTabsState extends State<ServerTabs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SnippetsDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Expanded(child: TabbedArea()),
        ),
      ),
    );
  }
}
