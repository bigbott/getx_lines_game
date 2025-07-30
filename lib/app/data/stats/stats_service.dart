

import 'package:appwrite/appwrite.dart';
import 'package:getx_lines_game/app/data/appwrite_constants.dart';

final class StatsService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Functions functions;

  StatsService() {
    client = Client()
        .setEndpoint(AppwriteConstants.ENDPOINT)
        .setProject(AppwriteConstants.PROJECT_ID);

    account = Account(client);
    databases = Databases(client);
    functions = Functions(client);
  }

  Future<Map<String, dynamic>> getStats (String userId) async {
     try {
      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID_STATS,
        queries: [Query.equal('user_id', userId)],
      );

      if (result.documents.isNotEmpty) {
        return result.documents.first.data;
      }
      return {};
    } on AppwriteException catch (e) {
      print(e.message);
      return {};
    }
  }

  Future<void> addPlayer(String userId, String nickname,) async {
    var now = DateTime.now();
    try {
      await databases.createDocument(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID_STATS,
        documentId: ID.unique(),
        data: {
          'user_id': userId, 
          'games_played': 0,
          'total_time_sec': 0,
          'last_played': now, 
          'first_played': now, 
        },
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}