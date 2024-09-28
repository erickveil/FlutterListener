import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class ListenerViewModel extends ChangeNotifier {
  ServerSocket? _serverSocket;
  bool _isListening = false;
  String _receivedMessages = "";

  // Public getters for UI
  bool get isListening => _isListening;
  String get receivedMessages => _receivedMessages;

  // Method to start the socket listener
  Future<void> startListener(int port) async {
    try {
      // Create the server socket and start listening
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _isListening = true;
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
