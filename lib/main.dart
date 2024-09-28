import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Socket Listener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListenerPage(),
    );
  }
}

class ListenerPage extends StatefulWidget {
  @override
  _ListenerPageState createState() => _ListenerPageState();
}

class _ListenerPageState extends State<ListenerPage> {
  final TextEditingController _portController = TextEditingController();
  bool isListening = false; // To manage listener status
  String receivedMessages = ""; // To display incoming messages

    /* Criticism:
     *
     * I notice that Flutter examples show an egregious ammount of nesting!
     * Whole objects being instantiated *inside the freaking constructor 
     * arguments of other classes*?!?
     * Gigantic argument lists?
     * 
     * This is offensive and it goes against well established best practices in 
     * programming...
     * 
     * Actually if I think about it more like a GUI layout document, like WPF,
     * QML, or HTML, it makes more sense. But I'd probably refactor this in a 
     * real project.
    */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Listener'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  onPressed: _toggleListener,
                  child: Text(isListening ? 'Stop Listener' : 'Start Listener'),
                ),
                SizedBox(width: 16.0),
                Text(
                  isListening ? 'Listening...' : 'Stopped',
                  style: TextStyle(
                    color: isListening ? Colors.green : Colors.red,
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
                    receivedMessages,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleListener() {
    setState(() {
      isListening = !isListening;
    });
  }
}
