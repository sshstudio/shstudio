import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/single_child_scroll_view_with_scrollbar.dart';
import 'package:sshstudio/widgets/split_view.dart';
import 'package:sshstudio/widgets/tabbed_area.dart';
import 'package:sshstudio/widgets/tree_list/tree_list.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: [TreeList()],
            ),
          ),
        ),
        view2: Container(
          child: TabbedArea(),
        ),
      )),
    );
  }
}
