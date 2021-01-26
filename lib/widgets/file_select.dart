import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';

class FileSelect extends StatefulWidget {
  final FormFieldValidator<String> validator;
  final Widget button;
  final double width;
  final String initialValue;
  final InputDecoration decoration;

  FileSelect({this.validator, this.button, this.width, this.initialValue, this.decoration});

  @override
  _FileSelectState createState() => _FileSelectState();
}

class _FileSelectState extends State<FileSelect> {

  String _errorText = '';

  @override
  Widget build(BuildContext context) {

    var _controller = TextEditingController(text: widget.initialValue);
    var decoration =  widget.decoration.copyWith(errorStyle:TextStyle(height: 0),);

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: widget.width,
              child: TextFormField(
                decoration: decoration,
                controller: _controller,
                validator: (value) {
                  var result = widget.validator(value);
                  setState(() {
                    _errorText = result == null ? '' : result;
                  });
                  return result;
                },
              ),
            ),
            ButtonTheme(
              height: 55,
              buttonColor: Colors.grey[100],
              child: ElevatedButton(
                onPressed: () => {
                  showOpenPanel(
                          canSelectDirectories: false, allowsMultipleSelection: false)
                      .then((FileChooserResult result) => setState(() {
                            _controller.text = result.paths[0];
                          }))
                },
                child: widget.button,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              _errorText,
              style: TextStyle(color: Colors.red[400], fontSize: 12),
            )
          ],
        )
      ],
    );
  }
}
