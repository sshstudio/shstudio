import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:sshstudio/models/server.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/services/s3.dart';
import 'package:sshstudio/utils/storage.dart';


class Sync {

  S3 _client;

  List<ServerFolder> _folders = [];

  Directory _workDir;

  Sync(this._folders) {
    _client = new S3();
  }

  Future<void> process() async {
    await Directory.current.createTemp().then((value) => _workDir = value);
    _client.upload(await _createArchive());
    _workDir.delete(recursive: true);
  }
  
  Future<String> _createArchive() async {

    var arcFolder = _workDir.path  + Platform.pathSeparator + 'servers';
    await Directory(arcFolder).create();
    await Directory(arcFolder + Platform.pathSeparator + 'keys').create();

    var serversFile = File( await Storage.getServersFile());
    serversFile.copySync(arcFolder + Platform.pathSeparator + 'servers.json');

    for (ServerFolder folder in _folders) {
      for (Server server in folder.servers) {
        if (server.key != '' && server.key != null && await File(server.key).exists()) {
          var keyFile = File(server.key);
          keyFile.copySync(arcFolder + Platform.pathSeparator + 'keys' + Platform.pathSeparator + server.id);
        }
      }
    }

    try {
      var encoder = ZipFileEncoder();
      encoder.zipDirectory(Directory(arcFolder),
          filename: _workDir.path + Platform.pathSeparator + 'servers.zip');
      encoder.close();
    } on FileSystemException  {
      print('exception');
    }
    
    
    return _workDir.path + Platform.pathSeparator + 'servers.zip';
  }
}