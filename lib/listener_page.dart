import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listener_viewmodel.dart';

class ListenerPage extends StatelessWidget {

  // This gives us some control over the text in the port input field.
  // We use this to disable turning the listener on if there is no port
  // defined.
  final TextEditingController _portController = 
    TextEditingController(text: '50502');


  Container createPortInput() {
    InputDecoration portInputHelperText = InputDecoration(
      labelText: 'Port Number',
      border: OutlineInputBorder(),
    );

    TextField portInputBox = TextField(
      controller: _portController,
      keyboardType: TextInputType.number,
      decoration: portInputHelperText,
    );

    Container portInputSizingBox = Container(
      width: 300,
      child: portInputBox,
    );

    return portInputSizingBox;
  }

  Row createControlPanel(ListenerViewModel viewModel) {
    TextStyle indicatorTextStyle = TextStyle( 
      color: viewModel.isListening 
        ? const Color.fromARGB(255, 46, 107, 48) 
        : const Color.fromARGB(255, 112, 29, 23),
      fontWeight: FontWeight.bold,
    );

    Text indicatorText = Text(
      viewModel.isListening ? 'Listening...' : 'Stopped',
      style: indicatorTextStyle,
    );

    // The state declaratively defines the button text:
    Text listenButtonText = Text(
      viewModel.isListening ? 'Stop Listener' : 'Start Listener'
    );

    ButtonStyle listenButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 162, 210, 234)
    );

    ElevatedButton listenButton = ElevatedButton(
      onPressed: () {
        if (_portController.text.isNotEmpty) {
          int port = int.parse(_portController.text);
          viewModel.toggleListener(port);
        }
      },
      style: listenButtonStyle,
      child: listenButtonText,
    );

    Row listenButtonRow = Row(
      children: [
        listenButton,
        SizedBox(width: 16.0),
        indicatorText,
      ],
    );

    return listenButtonRow;
  }

  Expanded createOutputBox(ListenerViewModel viewModel) {
    Text outputText = Text(
      viewModel.receivedMessages,
      style: TextStyle(fontSize: 16.0)
    );

    BoxDecoration outputBoxStyle = BoxDecoration(
      color: Color(0xffe6e8fa),
      border: Border.all(color: Colors.blueGrey),
      borderRadius: BorderRadius.circular(20.0),
    );

    Container outputBox = Container(
      width: 300,
      height: 150,
      padding: EdgeInsets.all(8.0),
      decoration: outputBoxStyle,
      // Just in case we get a lot of text in here:
      child: SingleChildScrollView( child: outputText ),
    );

    return Expanded(child: outputBox);
  }

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

                Container portInputBox = createPortInput();
                Row controlPanel = createControlPanel(viewModel);
                Expanded outputDataBox = createOutputBox(viewModel);
                SizedBox spacer = SizedBox(height: 16.0);

                Column pageRootColumn = Column(
                  // minimize the vertical space use
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    portInputBox,
                    spacer,
                    controlPanel,
                    spacer,
                    outputDataBox,
                  ],
                );

                return pageRootColumn;

              },
            ),
          ),
        ),
      ),
    );
  }
}
