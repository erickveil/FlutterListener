import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'listener_viewmodel.dart';
import 'listener_page.dart'; 

void main() async {
  // This section sets the starting window size
  // Weirdly this breaks my `Center` widget and nothing is centered anymore.
  // TODO: Look into relationship between window sizing and centering
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(400, 800));
    WindowManager.instance.setMaximumSize(const Size(400, 800));
  }

  // Inflates the widget and makes it the app root.
  runApp(
    // Allows you to provide multiple widgets to the provider tree.
    // Provider is for state management that allows the widgets to access a 
    // shared state.
    // Even though we only have one provider, we do this so we can scale later.
    MultiProvider(
      providers: [
        // This lets widgets listen to changes in the class and rebuild when 
        // the state changes.
        // ListenerViewModel extends ChangeNotifier so it can notify any 
        // listening widgets when the state changes.
        // So we can use the `notifyListeners()` method when we want to tell
        // all the widgets that state has changed.
        // `create` gets a lambda, and `(_)` is Dart for "no parameter used"
        ChangeNotifierProvider(create: (_) => ListenerViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Tell Dart compiler (and devs) that we are overriding the `build` method
  // from the superclass (StatelessWidget).
  // returns the MaterialApp Widget.
  // MaterialApp is a Material Design Application (like in Kotlin - Material 3).
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
