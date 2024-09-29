import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listener_viewmodel.dart';

class ListenerPage extends StatelessWidget {

  // This gives us some control over the text in the port input field.
  // We use this to disable turning the listener on if there is no port
  // defined.
  final TextEditingController _portController = 
    TextEditingController(text: '50502');

  @override
  Widget build(BuildContext context) {

    // Scaffold is a basic application container that provides a lot of basic
    // Application stuff in its members for free, like an AppBarr or a body.
    return Scaffold(
      body: Center(

        // Container and SizeBox are basic layout elements.
        // Container gives more options. In this case I didn't use any and 
        // Flutter keeps trying to get me to use the simpler SizeBox instead.
        child: Container(
          width: 350,

          // Padding is like a SizeBox, but instead of specifying a size, I 
          //define its layout by defining the space around `child`.
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            // Another Widget from the Provider package.
            // Lets me listen and react to changes in our ViewModel (the 
            // Provider).
            // Reads values from the Provider and rebuilds the UI when they
            // change.
            // Gives us the `builder` method so we can interact with the state.
            child: Consumer<ListenerViewModel>(

              // *context* - the current build context, lets us access other
              //     widgets or data from the widget tree. We don't really
              //     make use of that here.
              // *viewModel* - an instance of ListenerViewModel - you'll see 
              //     me use this to check the state before I do things here
              //     like set the text and color on the connection indicator.
              // *child* - a widget that doesn't need to be rebuilt (unused).
              builder: (context, viewModel, child) {
                return Column(
                  // minimize the vertical space use
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,

                      // This is where we enter the port number.
                      // A familiar and classic Control - I mean "Widget".
                      child: TextField(
                        // Here's where we connect the TextEditingController
                        // that we defined above.
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Port Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // Row! Just like in Qt/QML!
                    Row(
                      children: [

                        // We get to play with different types of button Widgets.
                        // ElevatedButton has a drop shadow.
                        ElevatedButton(
                            onPressed: () {

                              // Here's where we actually use the TextEditingController
                              // That we defined as a member and assigned to the port
                              // TextField.
                              if (_portController.text.isNotEmpty) {
                                int port = int.parse(_portController.text);

                                // Here we use our ListenerViewModel to turn
                                // the Listener on and off.
                                viewModel.toggleListener(port);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 162, 210, 234)),

                            // The state declaratively defines the button text:
                            child: Text(viewModel.isListening
                                ? 'Stop Listener'
                                : 'Start Listener')),

                        // Here I construct a custom widget out of other widgets
                        // like I would in QML - the state is again checked
                        // and helps define the appearance as it changes.
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

                    // Expanded lets its child expand to fill the available 
                    // space - another layout widget.
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

                        // Just in case we get a lot of text in here:
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
      ),
    );
  }
}
