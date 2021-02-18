import 'dart:io';

import 'package:aws_s3_client/aws_s3_client.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';


const PREFS_KEY_S3_KEY = 's3key';
const PREFS_KEY_S3_SECRET = 's3secret';
const PREFS_KEY_S3_BUCKET = 's3bucket';
const PREFS_KEY_S3_REGION = 's3region';
const PREFS_KEY_S3_HOST = 's3host';

class S3 {
  String _accessKeyId = '';
  String _secretKeyId = '';
  String _region = '';
  String _s3Endpoint = 'https://bucketname.s3-ap-southeast-1.amazonaws.com';
  String _bucket;

  S3() {
    SharedPreferences.getInstance().then((prefs) {
      _accessKeyId = prefs.getString(PREFS_KEY_S3_KEY);
      _secretKeyId = prefs.getString(PREFS_KEY_S3_SECRET);
      _bucket = prefs.getString(PREFS_KEY_S3_BUCKET);
      _region = prefs.getString(PREFS_KEY_S3_REGION);
      _s3Endpoint = "${prefs.getString(PREFS_KEY_S3_HOST)}/${_bucket}";
    });
  }

  Future<void> upload(String filePath) async {

    Bucket bucket = Bucket(region: _region, accessKey: _accessKeyId, secretKey: _secretKeyId, endpointUrl: _s3Endpoint);

    File file = File(filePath);

    var filename = basename(file.path);

    String etag = await bucket.uploadFile(
        'sshstudio/${filename}', file.readAsBytesSync(), 'text/plain', Permissions.private);
  }
}

