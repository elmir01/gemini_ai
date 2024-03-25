import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();

  TextEditingController _userControllor = TextEditingController();
  void scrollToBottom(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      // Bir sonraki frame'de işlemi gerçekleştir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userControllor.addListener(() {
      scrollToBottom(_userControllor);
    });
  }

  @override
  void dispose() {
    _userControllor.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static const apiKey = 'AIzaSyC9j204KTxtW4AnnNOj4ZlAb-wY0mBUd_I';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> _messages = [];
  Future<void> sendMessage() async {
    final message = _userControllor.text;
    _userControllor.clear();
    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? '', date: DateTime.now()));
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gemini Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: clearMessages,
            icon: Icon(
              Icons.restore,
              size: 35,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Messages(
                        isUser: message.isUser,
                        message: message.message,
                        date: DateFormat('HH:mm').format(message.date));
                  })),
          Row(
            children: [
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _userControllor,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        label: Text(
                          'Enter your message',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(Icons.send),
                  iconSize: 30,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(CircleBorder())),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 15).copyWith(
          left: isUser ? 100 : 10,
          right: isUser ? 10 : 100,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.pink.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: isUser ? Radius.circular(5) : Radius.zero,
            topRight: Radius.circular(5),
            bottomRight: isUser ? Radius.zero : Radius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                message,
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                date,
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;
  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}
