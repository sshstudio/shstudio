import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/screen/desktop/settings_screen.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/utils/storage.dart';
import 'package:sshstudio/widgets/data_access.dart';
import 'package:sshstudio/widgets/drawer/snippets.dart';
import 'package:sshstudio/widgets/file_select.dart';
import 'package:sshstudio/widgets/single_child_scroll_view_with_scrollbar.dart';
import 'package:sshstudio/widgets/split_view.dart';
import 'package:sshstudio/widgets/tabbed_area.dart';
import 'package:sshstudio/widgets/tree_list/tree_list.dart';

import '../../main.dart';

class MainScreenDesktop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainScreenDesktopState();
  }
}

class _MainScreenDesktopState extends State<MainScreenDesktop> {
  var _upd = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  export() {

    pickFile(context).then((path) {
      Storage.getServers().then((servers) {
        Storage.saveToFile(path, jsonEncode(servers), crypt: false);
      });
    });

    // showSavePanel(suggestedFileName: 'servers.json').then((value) {
    //   final paths = value.paths;
    //   for (int i = 0; i < paths.length; i++) {
    //     final path = paths[i];
    //     Storage.getServers().then((servers) {
    //       Storage.saveToFile(path, jsonEncode(servers), crypt: false);
    //     });
    //   }
    // });
  }

  import() {

    pickFile(context).then((path) {
      Storage.readFile(path, crypt: false).then((value) {
        setState(() {
          _upd = !_upd;
        });
        return ServerFolder.save(ServerFolder.fromJson(jsonDecode(value)));
      });
    });

    // showOpenPanel(canSelectDirectories: false, allowsMultipleSelection: false)
    //     .then((value) {
    //   final paths = value.paths;
    //   for (int i = 0; i < paths.length; i++) {
    //     final path = paths[i];
    //
    //     Storage.readFile(path, crypt: false).then((value) {
    //       setState(() {
    //         _upd = !_upd;
    //       });
    //       return ServerFolder.save(ServerFolder.fromJson(jsonDecode(value)));
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SnippetsDrawer(),
      body: SafeArea(
          child: SplitView(
        initialWeight: 1.4 / log(MediaQuery.of(context).size.width),
        // 0.178,
        viewMode: SplitViewMode.Horizontal,
        gripColor: lightBlue,
        gripSize: 3,
        view1: Container(
          child: SingleChildScrollViewWithScrollbar(
            scrollbarColor: Theme.of(context).accentColor.withOpacity(0.75),
            scrollbarThickness: 8.0,
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_upward),
                      onPressed: export,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: () {import(); StateContainer.of(context).state.updateList(); },
                    ),
                  ],
                ),
                TreeList(),
              ],
            ),
          ),
        ),
        view2: Container(
          child: Column(
            children: [
              StreamBuilder(
                stream: connectionsListener.onChange,
                builder: (context, snapshot) {
                  return snapshot.data == null? Container() : snapshot.data.activeConnection.id != '' ?
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_chart),
                        onPressed: (){
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                      )
                    ],
                  ) : Container();
                }
              ),
              Expanded(child: TabbedArea()),
            ],
          ),
        ),
      )),
    );
  }
}

