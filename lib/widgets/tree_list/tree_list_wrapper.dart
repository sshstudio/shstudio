import 'package:flutter/material.dart';
import 'package:sshstudio/widgets/tree_list/tree_list.dart';

import '../single_child_scroll_view_with_scrollbar.dart';

class TreeListWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {},// export,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () { /*import(); StateContainer.of(context).state.updateList(); */},
                ),
              ],
            ),
            TreeList(),
          ],
        ),
      ),
    );
  }

}