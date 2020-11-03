import 'package:flutter/material.dart';
import 'package:sshstudio/widgets/tabbed_area.dart';
import 'package:sshstudio/widgets/tree_list.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
            ),
              child:  Column(
                  children:[
                    SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 2, // 200,
                        // width: 400,
                        child: TreeList(),
                        ),
                    ),
                  ]
              ),
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