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

  Future<DocumentList?> loadItems({int offset = 0, int limit = 20}) async {
    DocumentList? res;
    try {
      res = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [
          Query.orderDesc('rank'),
          Query.limit(limit),
          Query.offset(offset),
        ],
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return res;
  }

  Future<DocumentList?> loadItemsAroundUser(String userId, {int limit = 20}) async {
    try {
      // First get user's position by counting documents with higher scores
      final userDoc = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [Query.equal('user_id', userId)],
      );

      if (userDoc.documents.isEmpty) return null;

      final userScore = userDoc.documents.first.data['scores'] as int;
      final higherScores = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [Query.greaterThan('scores', userScore)],
      );

      // Get half of the limit for scores above and below
      final halfLimit = limit ~/ 2;
      
      // Get players with higher scores
      final higherPlayers = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [
          Query.orderDesc('scores'),
          Query.limit(halfLimit),
          Query.greaterThan('scores', userScore),
        ],
      );

      // Get players with lower or equal scores
      final lowerPlayers = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [
          Query.orderDesc('scores'),
          Query.limit(halfLimit + 1), // +1 to include current user
          Query.lessThanEqual('scores', userScore),
        ],
      );

      // Combine the results
       return DocumentList(
         total: higherPlayers.total + lowerPlayers.total,
         documents: [...higherPlayers.documents, ...lowerPlayers.documents],
       );
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
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
