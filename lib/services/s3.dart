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
  String _key = '';
  String _secret = '';
  String _region = '';
  String _endpoint = 'https://bucketname.s3-ap-southeast-1.amazonaws.com';
  String _bucket;

  S3() {
    SharedPreferences.getInstance().then((prefs) {
      _key = prefs.getString(PREFS_KEY_S3_KEY);
      _secret = prefs.getString(PREFS_KEY_S3_SECRET);
      _bucket = prefs.getString(PREFS_KEY_S3_BUCKET);
      _region = prefs.getString(PREFS_KEY_S3_REGION);
      _endpoint = "${prefs.getString(PREFS_KEY_S3_HOST)}/$_bucket";
    });
  }

  String get bucket => _bucket;
  String get endpoint => _endpoint;

  Future<void> upload(String filePath) async {

    Bucket bucket = Bucket(region: _region, accessKey: _key, secretKey: _secret, endpointUrl: _endpoint);

    File file = File(filePath);

    var filename = basename(file.path);

    await bucket.uploadFile('sshstudio/$filename', file.readAsBytesSync(), 'text/plain', Permissions.private);
  }
}

