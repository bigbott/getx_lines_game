
import 'dart:io';
import 'dart:math';

import 'package:appwrite/appwrite.dart';

// Appwrite constants directly defined here to avoid dependencies
class AppwriteConstants {
  static const String PROJECT_ID = '6861211500017054125c';
  static const String DB_ID = '6867866f0015673602ab';
  static const String COLLECTION_ID = '686787330017241efa6b';
  static const String ENDPOINT = 'https://cloud.appwrite.io/v1';
}

// Simple nickname generator
class NicknameGenerator {
  static final random = Random();
  
  static String generate() {
    return '${adjectives[random.nextInt(adjectives.length)]} ${animals[random.nextInt(animals.length)]}';
  }
  
  static const List<String> adjectives = [
    'Happy', 'Clever', 'Brave', 'Mighty', 'Swift', 'Agile', 'Wise', 'Bold', 
    'Calm', 'Eager', 'Fierce', 'Gentle', 'Honest', 'Jolly', 'Kind', 'Lucky',
    'Noble', 'Proud', 'Quick', 'Smart', 'Tough', 'Witty', 'Zealous', 'Bright',
    'Daring', 'Elegant', 'Friendly', 'Graceful', 'Humble', 'Innocent', 'Joyful'
  ];
  
  static const List<String> animals = [
    'Lion', 'Tiger', 'Bear', 'Wolf', 'Fox', 'Eagle', 'Hawk', 'Dolphin', 'Shark',
    'Whale', 'Elephant', 'Giraffe', 'Zebra', 'Monkey', 'Gorilla', 'Penguin', 'Owl',
    'Rabbit', 'Deer', 'Moose', 'Beaver', 'Squirrel', 'Raccoon', 'Panda', 'Koala',
    'Kangaroo', 'Crocodile', 'Turtle', 'Snake', 'Lizard', 'Frog', 'Butterfly'
  ];
}

// Simple user ID generator
class UserIdGenerator {
  static String generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp.hashCode & 0xFFFF).toRadixString(36);
    return 'u${timestamp.substring(8)}$random'; // ~12 chars
  }
}

// Simple class to handle Appwrite operations without Flutter dependencies
class SimpleLeaderboardService {
  late final Client client;
  late final Databases databases;

  SimpleLeaderboardService() {
    client = Client()
        .setEndpoint(AppwriteConstants.ENDPOINT)
        .setProject(AppwriteConstants.PROJECT_ID);

    databases = Databases(client);
  }

  Future<void> addPlayer(String userId, String nickname, int score) async {
    try {
      await databases.createDocument(
        databaseId: AppwriteConstants.DB_ID,
        collectionId: AppwriteConstants.COLLECTION_ID,
        documentId: ID.unique(),
        data: {
          'user_id': userId,
          'nickname': nickname,
          'scores': score,
        },
      );
      print('Added player: $nickname with score $score');
    } catch (e) {
      print('Error adding player: $e');
      rethrow;
    }
  }
}

Future<void> main() async {
  final service = SimpleLeaderboardService();
  final random = Random();
  int successCount = 0;
  
  print('Starting to generate 100 random players...');
  
  for (int i = 0; i < 100; i++) {
    try {
      final userId = UserIdGenerator.generateUserId();
      final nickname = NicknameGenerator.generate();
      final score = random.nextInt(10000); // Random score between 0 and 9999
      
      await service.addPlayer(userId, nickname, score);
      successCount++;
      
      // Print progress
      print('Progress: $successCount/100');
      
      // Small delay to avoid overwhelming the API
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print('Failed to add player ${i+1}: $e');
    }
  }
  
  print('Finished generating players. Successfully added: $successCount/100');
  exit(0); // Ensure the program exits
}
