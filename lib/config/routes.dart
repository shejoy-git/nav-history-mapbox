import 'package:flutter/material.dart';
import 'package:nav_history/history/history.dart';
import 'package:nav_history/home/home.dart';
import 'package:nav_history/result/results.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.routeName: (context) => const HomeScreen(),
    ResultsScreen.routeName: (context) => const ResultsScreen(),
    HistoryScreen.routeName: (context) => const HistoryScreen(),
  };
}
