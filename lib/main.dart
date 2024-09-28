import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'listener_viewmodel.dart';
import 'listener_page.dart'; 

void main() async {
  // This section sets the starting window size
  // Weirdly this breaks my `Center` widget and nothing is centered anymore.
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(400, 800));
    WindowManager.instance.setMaximumSize(const Size(400, 800));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListenerViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Socket Listener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 195, 180, 153)
      ),
      home: ListenerPage(), 
    );
  }
}
