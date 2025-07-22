
import 'dart:convert';
import 'dart:io';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "update_rank", "data" : {"user_id": "a234234234sdf", "score":1096}}';
  String responseJson = await TestClient().call(json);
  print(responseJson);
  Map<String, dynamic> data = jsonDecode(responseJson);

  print(data['updated']);
  exit(0);
}