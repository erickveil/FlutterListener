import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listener_viewmodel.dart';

class ListenerPage extends StatelessWidget {
  final TextEditingController _portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Socket Listener'),
      //),
      body: Center ( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ListenerViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                // minimize the vertical space use
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _portController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Port Number',
                        border: OutlineInputBorder(),
                      ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 162, 210, 234)
                        ),
                        child: Text(viewModel.isListening 
                          ? 'Stop Listener' 
                          : 'Start Listener'
                          )
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        viewModel.isListening ? 'Listening...' : 'Stopped',
                        style: TextStyle(
                          color: viewModel.isListening 
                            ? const Color.fromARGB(255, 46, 107, 48) 
                            : const Color.fromARGB(255, 112, 29, 23),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Expanded(
                    child: Container(
                      width: 300,
                      height: 150,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xffe6e8fa),
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(20.0),
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
      ),
    );
  }
}
