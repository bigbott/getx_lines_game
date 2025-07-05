
/*
Uses NavigationHistoryObserver to print 
the current navigation stack
every time navigation stack changes
*/

import 'package:navigation_history_observer/navigation_history_observer.dart';

final class NavigationLogger {
  static String prevNavStack = '[]';
  static void init() {
    NavigationHistoryObserver().historyChangeStream.listen((change) {
      final stack = NavigationHistoryObserver().history;
      print(change.action.toString());
     // print('Navigation Stack (${stack.length} routes):');
      String navStack = '[';
      for (var i = 0; i < stack.length; i++) {
       // final route = stack[i];
         navStack += stack[i].settings.name! + ', ';
       // print('  $i: ${route.settings.name ?? 'unnamed'}');
      }
      navStack += ']';
      print('Nav stack before: ' + prevNavStack);
      print('Nav stack now: ' + navStack);
      prevNavStack = navStack;
    });
  }
}