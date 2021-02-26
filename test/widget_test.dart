// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sshstudio/models/server_folder.dart';
import 'package:sshstudio/services/sync.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {






    var list1 = [
      {
        "title": "OIS",
        "servers": [
          {
            "id": "1",
            "title": "openitstudio.ru",
            "url": "openitstudio.ru",
            "login": "fgorsky",
            "password": "testpsw",
            "port": 22,
            "key": "/Users/fgorsky/.ssh/id_rsa",
            "snippets": [
              {
                "id": "72105a28-53e3-4928-933f-dd1b5f89ca32",
                "title": "ls",
                "command": "ls -la /etc"
              }
            ]
          },
          {
            "id": "788756c9-c663-4df3-8043-01b1c9dbef78",
            "title": "vipclinic",
            "url": "80.87.201.250",
            "login": "root",
            "password": "JiYJJGgsMc",
            "port": 22,
            "key": null,
            "snippets": null
          },
          {
            "id": "9165e107-bd8d-4b3d-9532-3fbf32a0b5cd",
            "title": "sentry",
            "url": "sentry.openitstudio.ru",
            "login": "fgorsky",
            "password": "p",
            "port": 22,
            "key": "/Users/fgorsky/.ssh/id_rsa",
            "snippets": null
          },
          {
            "id": null,
            "title": "testsrv1",
            "url": "ss",
            "login": "ss",
            "password": "ss",
            "port": 22,
            "key": "",
            "snippets": null
          }
        ],
        "id": "22a9e169-2eac-4c3e-997a-8bb945dbbadc"
      }
    ] as List<ServerFolder>;

    var list2 = [
      {
        "title": "OIS",
        "servers": [
          {
            "id": "1",
            "title": "openitstudio.ru",
            "url": "openitstudio.ru",
            "login": "fgorsky",
            "password": "testpsw",
            "port": 22,
            "key": "/Users/fgorsky/.ssh/id_rsa",
            "snippets": [
              {
                "id": "72105a28-53e3-4928-933f-dd1b5f89ca32",
                "title": "ls",
                "command": "ls -la /etc"
              },
              {
                "id": "72105a28-53e3-4928-933f-dd1b5f89ca33",
                "title": "ls",
                "command": "ls -la /home"
              }
            ]
          },
          {
            "id": "2",
            "title": "test.ru",
            "url": "test.ru",
            "login": "fgorsky",
            "password": "testpsw",
            "port": 22,
            "key": "/Users/fgorsky/.ssh/id_rsa",
            "snippets": [
              {
                "id": "72105a28-53e3-4928-933f-dd1b5f89ca34",
                "title": "ls",
                "command": "ls -la /etc"
              }
            ]
          },
        ],
        "id": "22a9e169-2eac-4c3e-997a-8bb945dbbadc"
      }
    ] as List<ServerFolder>;

    var list3 = Sync.mergeLists(list1, list2);

    print(list3);


  });

}
