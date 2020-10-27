import 'package:flutter/material.dart';
import 'package:sshstudio/widgets/atbbed_area.dart';
import 'package:sshstudio/widgets/tree_list.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 200,
              child: TreeList(),
            ),
            Expanded(
              child:TabbedArea(),
            )
          ],
        ),
      ),
    );
  }

}