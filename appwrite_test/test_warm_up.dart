

import 'dart:io';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "warm_up", "data" : {} }';
  String responseJson = await TestClient().call(json);


  print('Warmed up successfully');
  exit(0);
}