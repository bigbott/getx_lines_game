

import 'package:appwrite/appwrite.dart';

import 'appwrite_constants.dart';


final _appwrite = _Appwrite();

class _Appwrite {
  _Appwrite() {
    _init();
  }

  late final Client client;
  late final Functions functions;

  void _init() {
    client = Client()
        .setEndpoint(AppwriteConstants.ENDPOINT)
        .setProject(AppwriteConstants.PROJECT_ID);
    functions = Functions(client);
  }
}


final class TestClient {
  Future<String> call(String json) async {
    try {
      final execution = await _appwrite.functions
          .createExecution(functionId: AppwriteConstants.FUNCTION_ID, body: json);

      return execution.responseBody;
    } on AppwriteException catch (e) {
      print(e.message);
      throw Exception(e);
    }
  }
}

