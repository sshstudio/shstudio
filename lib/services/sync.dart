import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  process() async {

    await Directory.current.createTemp().then((value) => _workDir = value);
    var local = await _createArchive();
    var remote = await _extractArchive();

    var mergedList = [];

    if (await _isLocalMain(remote)) {
      mergedList = await _merge(local, remote);
    } else {
      mergedList = await _merge(remote, local);
    }

    ServerFolder.save(mergedList);

    _workDir.delete(recursive: true);
    await Directory.current.createTemp().then((value) => _workDir = value);
    _client.upload(await _createArchive());
    _workDir.delete(recursive: true);
  }

  Future<bool> _isLocalMain(String remote) async {
    var localTime = await SharedPreferences.getInstance().then((prefs) => prefs.getInt(PREFS_KEY_LAST_SYNC_TIME));

    if (localTime == null) {
      return false;
    }

    var meta = await Storage.readFile(remote + Platform.pathSeparator + 'meta');
    var remoteTime = int.parse(meta);

    return remoteTime < localTime;
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

    var metaFile = File(arcFolder + 'meta');
    await metaFile.writeAsString(DateTime.now().millisecondsSinceEpoch.toString());

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

  Future<String> _extractArchive() async {

    var downloadedArc = await _downloadFile(_remoteArcUri(), 'download.zip', _workDir.path);

    // Read the Zip file from disk.
    final bytes = File(downloadedArc).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(_workDir.path+ Platform.pathSeparator + 'out' + Platform.pathSeparator + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(_workDir.path+ Platform.pathSeparator + 'out' + Platform.pathSeparator + filename)
          ..create(recursive: true);
      }
    }

    return _workDir.path+ Platform.pathSeparator + 'out' + Platform.pathSeparator;
  }

  Future<List<ServerFolder>> _merge(String pathMain, String pathSecondary) async {

    var result = [];

    List<ServerFolder> mContent = ServerFolder.fromJson(jsonDecode(await Storage.readFile(pathMain + Platform.pathSeparator + 'servers.json')));
    List<ServerFolder> sContent = ServerFolder.fromJson(jsonDecode(await Storage.readFile(pathSecondary + Platform.pathSeparator + 'servers.json')));

    for(final folder in mContent) {
      for(final compareFolder in sContent) {

      }
    }

    return result;
  }

  String _remoteArcUri() {
    return _client.endpoint+'/sshstudio/servers.zip';
  }

  Future<String> _downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      }
      else {
        throw Exception(
            'failed to download syn archive ' + response.statusCode.toString());
      }
    }
    catch(ex){
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}