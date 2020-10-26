

import 'package:flutter/material.dart';

import '../main.dart';

class TabbedArea extends StatefulWidget {
  @override
  _TabbedAreaState createState() => new _TabbedAreaState();
}

class _TabbedAreaState extends State<TabbedArea> with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4, // length of tabs
        initialIndex: 0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Container(
            child: TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
                Tab(text: 'Tab 3'),
                Tab(text: 'Tab 4'),
              ],
            ),
          ),
          Container(
              height: 400, //height of TabBarView
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
              ),
              child: TabBarView(children: <Widget>[
                Container(
                  child: Center(


                    child: MyHomePage(),// Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text('Display Tab 2', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text('Display Tab 3', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text('Display Tab 4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
              ])
          )
        ])
    );
  }

}