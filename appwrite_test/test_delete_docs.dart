
import 'dart:convert';
import 'dart:io';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "delete_docs", "data" : {} }';
  String responseJson = await TestClient().call(json);
  //List<dynamic> data = jsonDecode(responseJson);
 // Map<String, dynamic> firstEntry = data[0] as Map<String, dynamic>;
  Map<String, dynamic> data = jsonDecode(responseJson);
  bool success =  data['success'];
  if (success){
      print('total ' + data['total'].toString());
      print('count ' + data['count'].toString());
  } else {
     print(data['error']);
  }
 
  exit(0);
}