import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:getx_lines_game/app/data/leaderboard/appwrite_constants.dart';

final class LeaderboardService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Functions functions;

  LeaderboardService() {
    client = Client()
        .setEndpoint(AppwriteConstants.ENDPOINT)
        .setProject(AppwriteConstants.PROJECT_ID);

    account = Account(client);
    databases = Databases(client);
    functions = Functions(client);
  }

  Future<DocumentList?> loadItems({int offset = 0, int limit = 20}) async {
    DocumentList? res;
    try {
      res = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [
          Query.orderAsc('rank'),
          Query.limit(limit),
          Query.offset(offset),
        ],
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return res;
  }

  Future<DocumentList?> loadItemsAroundUser(String userId) async {
    try {
      // First get user's document to find their rank
      final userDoc = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [Query.equal('user_id', userId)],
      );

      if (userDoc.documents.isEmpty) return null;

      final userRank = userDoc.documents.first.data['rank'] as int;
      final minRank = (userRank - 7).clamp(1, double.infinity).toInt();
      final maxRank = userRank + 10;

      // Get all players within rank range
      final players = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [
          Query.between('rank', minRank, maxRank),
          // Query.greaterThanEqual('rank', minRank),
          // Query.lessThanEqual('rank', maxRank),
          Query.orderAsc("rank")
        ],
      );

      return players;
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

  Future<int> _calculateRank(int score) async {
    try {
      final higherScores = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        queries: [Query.greaterThan('scores', score), Query.limit(1)],
      );
      return higherScores.total + 1; // Rank starts from 1
    } on AppwriteException catch (e) {
      print(e.message);
      return 1; // Default to top rank if error occurs
    }
  }

  Future<void> updateUserScore(String userId, String nickname, int score) async {
    try {
      // Check if user already has a document
      final documentId = await getUserDocumentId(userId);

      int rank = await _calculateRank(score);

      DateTime now = DateTime.now();

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
            'rank': rank,
            'last_played': now,
          },
        );
      } else {
        // Create new document
        await addItem({
          'user_id': userId,
          'nickname': nickname,
          'scores': score,
          'rank': rank,
          'last_played': now,
        });
      }

      _updateRanksBelowUser(userId, score);
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  void _updateRanksBelowUser(String userId, int score) async {
    try {
      await _warmUpFunction();
      String json =
          '{"commandName": "update_rank", "data" : {"user_id": "$userId", "score":$score}}';

      final execution = await functions.createExecution(
          functionId: AppwriteConstants.FUNCTION_ID, body: json);
      String responseJson = execution.responseBody;
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  _warmUpFunction() async {
    try {
      String json = '{"commandName": "warm_up", "data" : {} }';
      await functions.createExecution(
        functionId: AppwriteConstants.FUNCTION_ID, body: json);
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}
