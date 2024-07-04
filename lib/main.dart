import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nav_history/config/routes.dart';
import 'package:nav_history/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('nav_history');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nav-History',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
