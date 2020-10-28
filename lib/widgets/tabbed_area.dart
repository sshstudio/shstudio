import 'package:flutter/material.dart';
import 'package:sshstudio/models/connections.dart';
import 'package:sshstudio/models/server.dart';

import '../main.dart';

class TabbedArea extends StatefulWidget {
  @override
  _TabbedAreaState createState() => new _TabbedAreaState();
}

class _TabbedAreaState extends State<TabbedArea> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<TabbedArea> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: connectionsListener.onChange,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.connections.length < 1) {
          return Text('select server to connect');
        }
        return DefaultTabController(
            initialIndex: 0,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              Container(
                child: TabBar(
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: _tabs(snapshot.data),
                ),
              ),
              Container(
                  height: 400, //height of TabBarView
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                  ),
                  child: TabBarView(children: _tabsContent(snapshot.data))
              )
            ]),
            length: snapshot.data == null ? 0 : _tabsContent(snapshot.data).length, // length of tabs
        );
      }
    );
  }

  List<Widget> _tabs(Connections pool) {
    return pool == null ? [] : pool.connections.entries.map((MapEntry<String, Server> entry) => Tab(
      child: Row(
        children: [
          Text(entry.value.title + ''),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              connectionsPool.closeConnection(entry.key);
            },
          )
        ],
      ),
    )).toList();
  }

  List<Widget> _tabsContent(Connections pool) {
    return pool == null ? [] : pool.connections.entries.map((MapEntry<String, Server> entry) => Container(
      child: Center(
        child: Text('Display Tab '+entry.value.id.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    )).toList();

  }

  @override
  bool get wantKeepAlive => true;

}