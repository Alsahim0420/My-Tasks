// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_task/providers/providers.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.deepPurple, // background bar color
        statusBarIconBrightness: Brightness.dark, // bar Icons color
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => TaskProvider()..loadTasks(),
      child: MaterialApp(
        title: "My Task's",
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}
