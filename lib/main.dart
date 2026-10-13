import 'package:flutter/material.dart';

import 'UILibrary/View/Pages/RootShell.dart';
import 'UILibrary/View/Theme/AppTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FixItApp());
}


class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const RootShell(),
    );
  }
}



