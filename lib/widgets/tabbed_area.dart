import 'package:flutter/material.dart';
import 'package:sshstudio/models/connections.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/widgets/ssh_terminal.dart';

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
          return Center(child: Text('select server to connect', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),) ;
        }
        return DefaultTabController(
            initialIndex: snapshot.data.connections.length - 1,
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
        child: SshTerminal(entry.value, entry.key),
      ),
    )).toList();

  }

  @override
  bool get wantKeepAlive => true;

}