
import 'dart:convert';
import 'dart:io';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "create_users", "data" : {} }';
  String responseJson = await TestClient().call(json);
  Map<String, dynamic> data = jsonDecode(responseJson);

  bool success = data['success'];
  if (success){
    print (data['created']);
  } else {
     print (data['error']);
  }

  exit(0);
}