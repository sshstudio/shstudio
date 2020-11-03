import 'package:flutter/material.dart';

class AddServerWindow extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

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