
import 'dart:convert';

import 'test_client.dart';

void main () async{
  String json = '{"commandName": "sum", "data" : [{"num1":2},{"num2":3}] }';
  String responseJson = await TestClient().call(json);
  List<dynamic> data = jsonDecode(responseJson);
  Map<String, dynamic> firstEntry = data[0] as Map<String, dynamic>;

  print(firstEntry['sum']);
}