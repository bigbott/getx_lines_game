import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:getx_lines_game/app/data/leaderboard/appwrite_constants.dart';

final class LeaderboardService {
  late final Client client;
  late final Account account;
  late final Databases databases;

  LeaderboardService() {
    client = Client()
        .setEndpoint(AppwriteConstants.ENDPOINT)
        .setProject(AppwriteConstants.PROJECT_ID);

    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList?> loadItems() async {
    DocumentList? res;
    try {
      res = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return res;
  }

  Future<void> addItem(Map<String, dynamic> data) async {
    try {
      await databases.createDocument(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        documentId: ID.unique(),
        data: data,
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
  
  Future<String?> getUserDocumentId(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [Query.equal('user_id', userId)],
      );
      
      if (result.documents.isNotEmpty) {
        return result.documents.first.$id;
      }
      return null;
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }
  
  Future<void> updateUserScore(String userId, String nickname, int score) async {
    try {
      // Check if user already has a document
      final documentId = await getUserDocumentId(userId);
      
      if (documentId != null) {
        // Update existing document
        await databases.updateDocument(
          databaseId: AppwriteConstants.DB_ID,
          collectionId: AppwriteConstants.COLLECTION_ID,
          documentId: documentId,
          data: {
            'user_id': userId,
            'nickname': nickname,
            'scores': score,
          },
        );
      } else {
        // Create new document
        await addItem({
          'user_id': userId,
          'nickname': nickname,
          'scores': score,
        });
      }
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}
