
import 'dart:convert';
import 'dart:io';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "doc_count", "data" : {} }';
  String responseJson = await TestClient().call(json);
  //List<dynamic> data = jsonDecode(responseJson);
 // Map<String, dynamic> firstEntry = data[0] as Map<String, dynamic>;
  Map<String, dynamic> data = jsonDecode(responseJson);

  print(data['count']);
  exit(0);
}