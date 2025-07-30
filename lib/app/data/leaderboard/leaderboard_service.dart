import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:getx_lines_game/app/data/appwrite_constants.dart';

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

  // Future<DocumentList?> loadItems(int offset = 0, int limit = 20}) async {
  //   DocumentList? res;
  //   try {
  //     res = await databases.listDocuments(
  //       databaseId: AppwriteConstants.DB_ID,
  //       collectionId: AppwriteConstants.COLLECTION_ID,
  //       queries: [
  //         Query.orderAsc('rank'),
  //         Query.limit(limit),
  //         Query.offset(offset),
  //       ],
  //     );
  //   } on AppwriteException catch (e) {
  //     print(e.message);
  //   }
  //   return res;
  // }

   Future<DocumentList?> loadTopPlayers(String collectionId) async {
         DocumentList? res;
    try {
      res = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
        queries: [
          Query.orderAsc('rank'),
          Query.limit(15),
          Query.offset(0),
        ],
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
    return res;
   }

  Future<DocumentList?> loadPlayersAround(String collectionId, String userId) async {
    try {
      // First get user's document to find their rank
      final userDoc = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
        queries: [Query.equal('user_id', userId)],
      );

      if (userDoc.documents.isEmpty) return null;

      final userRank = userDoc.documents.first.data['rank'] as int;
      final minRank = (userRank - 7).clamp(1, double.infinity).toInt();
      final maxRank = userRank + 10;

      // Get all players within rank range
      final players = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
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

    Future<void> addPlayer(String collectionId, String userId, String nickname, int score) async {
    int rank = await _calculateRank(collectionId, score);
    try {
      await databases.createDocument(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          'user_id': userId, 
          'nickname': nickname,
          'score': score,
          'rank': rank, 
        },
      );
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }



  Future<String?> getUserDocumentId(String collectionId, String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
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

  Future<int> _calculateRank(String collectionId, int score) async {
    try {
      final higherScores = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
        queries: [Query.greaterThan('score', score), Query.limit(1)],
      );
      return higherScores.total + 1; // Rank starts from 1
    } on AppwriteException catch (e) {
      print(e.message);
      return 1; // Default to top rank if error occurs
    }
  }

  Future<void> updateUserScore(String collectionId, String userId, String nickname, int score) async {
    try {
      // Check if user already has a document
      final documentId = await getUserDocumentId(collectionId, userId);

      int rank = await _calculateRank(collectionId, score);

      if (documentId != null) {
        // Update existing document
        await databases.updateDocument(
          databaseId: AppwriteConstants.DB_ID,
          collectionId: collectionId,
          documentId: documentId,
          data: {
            'user_id': userId,
            'nickname': nickname,
            'score': score,
            'rank': rank,
          },
        );
      } else {
        // Create new document
        await addPlayer(collectionId, userId, nickname, score);
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

  Future<int> getUserScore(String collectionId, String userId) async{
      try {
      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
        queries: [Query.equal('user_id', userId)],
      );

      if (result.documents.isNotEmpty) {
        return result.documents.first.data['score'];
      }
      return 0;
    } on AppwriteException catch (e) {
      print(e.message);
      return 0;
    }
  }

  Future<int> getTopScore(String collectionId) async{
      try {
      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: collectionId,
        queries: [Query.equal('rank', 1)],
      );

      if (result.documents.isNotEmpty) {
        return result.documents.first.data['score'];
      }
      return 0;
    } on AppwriteException catch (e) {
      print(e.message);
      return 0;
    }
  }
}
