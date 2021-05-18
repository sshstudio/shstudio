import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sshstudio/utils/constants.dart';

import '../main.dart';

class FileSelect extends StatefulWidget {
  final FormFieldValidator<String> validator;
  final Widget button;
  final double width;
  final String initialValue;
  final InputDecoration decoration;

  FileSelect(
      {this.validator,
      this.button,
      this.width,
      this.initialValue,
      this.decoration});

  @override
  _FileSelectState createState() => _FileSelectState();

  static Future<String> pickFile(BuildContext context) {
    if (isDesktop) {
      return openFile().then((value) => value.path);
    } else {
      return FilesystemPicker.open(
        title: 'Open file',
        context: context,
        rootDirectory: Directory(Platform.pathSeparator),
        fsType: FilesystemType.file,
        folderIconColor: darkBlue,
        // allowedExtensions: [''],
        fileTileSelectMode: FileTileSelectMode.checkButton,
        requestPermission: () async =>
        await Permission.storage.request().isGranted,
      ).then((result) => result);
    }
  }
}

class _FileSelectState extends State<FileSelect> {
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController(text: widget.initialValue);
    var decoration = widget.decoration.copyWith(
      errorStyle: TextStyle(height: 0),
    );

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
                  onPressed: () =>
                  {
                    filePick(_controller)
                  },
                  child: widget.button,
                )),
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

  Future<void> filePick(TextEditingController _controller) async {

    FileSelect.pickFile(context).then((value) {
      _controller.text = value;
    });
  }

}

