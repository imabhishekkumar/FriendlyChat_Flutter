import 'package:flutter/material.dart';

void main() => runApp(MyApp());
const String _name = "You";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendly Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendly Chat")),
      body: new Column(
        //modified
        children: <Widget>[
          //new
          new Flexible(
            //new
            child: new ListView.builder(
              //new
              padding: new EdgeInsets.all(8.0), //new
              reverse: true, //new
              itemBuilder: (_, int index) => _messages[index], //new
              itemCount: _messages.length, //new
            ), //new
          ), //new
          new Divider(height: 1.0), //new
          new Container(
            //new
            decoration:
                new BoxDecoration(color: Theme.of(context).cardColor), //new
            child: _buildTextComposer(), //modified
          ), //new
        ], //new
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onChanged: (String text) {
                  //new
                  setState(() {
                    //new
                    _isComposing = text.length > 0; //new
                  }); //new
                }, //new
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing
                    ? () =>
                        _handleSubmitted(_textEditingController.text) //modified
                    : null, //modified
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      //new
      _isComposing = false; //new
    });
    ChatMessage message = new ChatMessage(
      //new
      text: text,
      animationController: new AnimationController(
        //new
        duration: new Duration(milliseconds: 700), //new
        vsync: this, //new
      ), //new
    ); //new
    setState(() {
      //new
      _messages.insert(0, message); //new
    });
    message.animationController.forward();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        //new
        sizeFactor: new CurvedAnimation(
            //new
            parent: animationController,
            curve: Curves.easeOut), //new
        axisAlignment: 0.0, //new
        child: new Container(
          //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ],
          ),
        ) //new
        );
  }
}
