import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

// For true MVVM, I should have broken the socket stuff out into its own 
// Model class, but it's mashed in here because this is a weekend project.

class ListenerViewModel extends ChangeNotifier {

  // I remember the good old days when setting up a socket was PAINFUL, dammit!
  // The `?` tells us that _serverSocket can be null.
  // We just declare it here, and will define it later.
  ServerSocket? _serverSocket;

  // Here are our state values! This is where the magic happens.
  bool _isListening = false;
  String _receivedMessages = "";

  // Public getters for UI
  bool get isListening => _isListening;
  String get receivedMessages => _receivedMessages;

  // Method to start the socket listener
  // `Future<void>` tells us this method is async.
  // A `Future` is a value or error that will be available in the future.
  // This one is `void` and so will not return anything when it's done.
  // But we want the async so we don't block the UI while listening.
  Future<void> startListener(int port) async {
    try {
      // Create the server socket and start listening
      // Here we pause execution until the `bind` is complete.
      // `await` will block the execution of this function *but not the main
      // thread* so the UI will not freeze.
      // Also, we can only await methods that return a Future.
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _isListening = true;

      // We don't append the string here - each new session clears the output box.
      _receivedMessages = "Listening on port $port...\n";
      notifyListeners();

      // Handle new connections
      _serverSocket!.listen((Socket client) {
        _handleClient(client);
      });
    } catch (e) {
      _receivedMessages += "Error starting listener: $e\n";
      notifyListeners();
    }
  }

  // Method to stop the socket listener
  void stopListener() {
    _serverSocket?.close();
    _serverSocket = null;
    _isListening = false;
    _receivedMessages += "Listener stopped.\n";
    notifyListeners();
  }

  // Toggle listener state
  void toggleListener(int port) {
    if (_isListening) {
      stopListener();
    } else {
      startListener(port);
    }
  }

  // Handle a new client connection
  void _handleClient(Socket client) {
    client.listen((List<int> data) {
      // Decode incoming data as a string
      String message = String.fromCharCodes(data).trim();
      _receivedMessages += "Received: $message\n";
      notifyListeners();

      // Send back an echo response
      client.write("Echo: $message\n");
    }, onDone: () {
      client.close();
    });
  }
}
