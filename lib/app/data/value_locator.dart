import 'package:getx_lines_game/app/data/appwrite_constants.dart';

final VL = ValueLocator._();

final class ValueLocator {
  ValueLocator._() {
    init();
  }

  Map<String, dynamic> map = {};
  List<String> keyList = [];

  void put(String key, dynamic value) {
    if (!keyList.contains(key)){
      throw Exception('VL doesn`t have the key: $key');
    }
    map[key] = value;
  }

  dynamic find(String key) {
    if (!keyList.contains(key)){
      throw Exception('VL doesn`t have the key: $key');
    }
    return map[key];
  }

  void init() {
    map[COLLECTION_ID] = AppwriteConstants.COLLECTION_ID_7X7;
    map[GRID_WIDTH] = 7;
    map[GRID_HEIGHT] = 7;
    map[NUMBER_OF_BALLS] = 4;
    keyList.add(COLLECTION_ID);
    keyList.add(GRID_WIDTH);
    keyList.add(GRID_HEIGHT);
    keyList.add(STATS_USER_ID);
    keyList.add(NUMBER_OF_BALLS);
  }

  final COLLECTION_ID = 'collection_id';
  final GRID_WIDTH = 'grid_width';
  final GRID_HEIGHT = 'grid_height';
  final NUMBER_OF_BALLS = 'number_of_balls';
  final STATS_USER_ID = 'stats_user_id';

  
}
