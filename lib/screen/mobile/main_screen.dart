import 'package:flutter/material.dart';
import 'package:sshstudio/widgets/tabbed_area.dart';
import 'package:sshstudio/widgets/tree_list/tree_list.dart';

class MainScreenMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: SafeArea(child: TreeList()),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TabbedArea()
              ],
          ),
        ),
      ),
    );
  }
}