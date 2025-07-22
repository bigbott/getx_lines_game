
import 'dart:convert';
import 'dart:io';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "doc_count_higher_score", "data" : {"score":300}}';
  String responseJson = await TestClient().call(json);
  print(responseJson);
  Map<String, dynamic> data = jsonDecode(responseJson);

  print(data['count']);
  exit(0);
}