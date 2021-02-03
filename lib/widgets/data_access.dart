import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sshstudio/models/server_folder.dart';


class DataAccess extends StatefulWidget {
  final Widget child;


  DataAccess({@required this.child}) : super();

  @override
  State<StatefulWidget> createState() {
    return new _DataAccessState();
  }

  static _DataAccessState of(BuildContext context) =>
      StateContainer.of(context)?.state;

}

class _DataAccessState extends State<DataAccess> {

  List<ServerFolder> _servers = [];


  get servers => _servers;

  void updateList() {
    ServerFolder.getList().then((value) => setState(() {
      _servers = value;
    }));
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return StateContainer(child: widget.child, state: this);
  }

  @override
  void didUpdateWidget(DataAccess oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Конфигурация виджета изменилась
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Изменилась конфигурация InheritedWidget'ов
    // Также вызывается после initState, но до build'а
  }

  @override
  void dispose() {
    // Перманетное удаление стейта из дерева
    super.dispose();
  }

}

class StateContainer extends InheritedWidget {

  final _DataAccessState state;

  StateContainer({Key key, Widget child, @required this.state}): super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant StateContainer oldWidget) => true;

  static StateContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StateContainer>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'Scope of DataScope',
            ),
          )
          ..add(
            ObjectFlagProperty<_DataAccessState>(
              '_DataScopeState',
              state,
              ifNull: 'none',
            ),
          )
          ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.offstage,
      );
}


