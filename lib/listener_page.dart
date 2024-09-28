import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listener_viewmodel.dart';

class ListenerPage extends StatelessWidget {
  final TextEditingController _portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Listener'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ListenerViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _portController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Port Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_portController.text.isNotEmpty) {
                          int port = int.parse(_portController.text);
                          viewModel.toggleListener(port);
                        }
                      },
                      child: Text(viewModel.isListening ? 'Stop Listener' : 'Start Listener'),
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      viewModel.isListening ? 'Listening...' : 'Stopped',
                      style: TextStyle(
                        color: viewModel.isListening ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        viewModel.receivedMessages,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
