import 'package:flutter/material.dart';
import 'package:sshstudio/widgets/tabbed_area.dart';
import 'package:sshstudio/widgets/tree_list.dart';

class MainScreen extends StatelessWidget {

  final double bottomButtonsHeight = 100;

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
                        height: MediaQuery.of(context).size.height - bottomButtonsHeight - 2, // 200,
                        // width: 400,
                        child: TreeList(),
                        ),
                    ),

                    Container(
                      height: bottomButtonsHeight,
                      child: Row(
                        children: [
                          IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _addWindow(context);
                                  });
                            },
                          ),
                        ],
                      ),
                    )

                    //
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



  Widget _addWindow(context) {
    return AlertDialog(
      content: Stack(
        children: <Widget>[
          Form(
            // key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();
                      // }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();
                      // }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}