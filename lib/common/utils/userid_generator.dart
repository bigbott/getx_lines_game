class UserIdGenerator {
  // Option 1: Generate compact user IDs (12 chars)
  static String generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp.hashCode & 0xFFFF).toRadixString(36);
    return 'u${timestamp.substring(8)}$random'; // ~12 chars
  }
  
}