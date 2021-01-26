import 'package:flutter/material.dart';
import 'package:sshstudio/models/connections.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/utils/constants.dart';
import 'package:sshstudio/widgets/ssh_terminal.dart';

import '../main.dart';

class TabbedArea extends StatefulWidget {
  @override
  _TabbedAreaState createState() => new _TabbedAreaState();
}

class _TabbedAreaState extends State<TabbedArea> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TabbedArea> {

  @override
  Widget build(BuildContext context) {

    super.build(context);
    TabController _tabController;

    return StreamBuilder(
      stream: connectionsListener.onChange,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.connections.length < 1) {
          return Center(child: Text('select server to connect', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),) ;
        }

        Connections connections = snapshot.data;

        var length = connections.connections.length;
        _tabController = new TabController(vsync: this, length: length);

        List list = connections.toList();
        var initialIndex = connections.connections.length - 1;
        list.asMap().forEach((index, element) {
          if (element.id == connections.activeConnection.id) {
            initialIndex = index;
            _tabController.animateTo(index);
          }
        });

        return DefaultTabController(
            initialIndex: initialIndex,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              Container(
                child: TabBar(
                  controller: _tabController,
                  labelColor: darkBlue,
                  unselectedLabelColor: Colors.black,
                  tabs: _tabs(connections),
                  onTap: (index) {
                    var els = connections.toList();
                    connections.setActiveConnection(els[index]);
                    print(els[index]);
                  },
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 48 - 40, //height of TabBarView && height of top menu
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                  ),
                  child: TabBarView(children: _tabsContent(connections), controller: _tabController,)
              )
            ]),
            length: connections == null ? 0 : length, // length of tabs
        );
      }
    );
  }

  List<Widget> _tabs(Connections pool) {
    return pool == null ? [] : pool.connections.entries.map((MapEntry<String, Server> entry) => Tab(
      child: Row(
        children: [
          Text(entry.value.title + ''),
          Spacer(),
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