import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test_ai/model/message.dart';
import 'package:test_ai/views/home_screen.dart';

class HomeViewModel extends ChangeNotifier{
  ScrollController scrollController = ScrollController();
  TextEditingController userControllor = TextEditingController();
  void scrollToBottom(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
    static const apiKey = 'AIzaSyC9j204KTxtW4AnnNOj4ZlAb-wY0mBUd_I';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> messages = [];
  Future<void> sendMessage() async {
    final message = userControllor.text;
    userControllor.clear();
      messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
          notifyListeners();
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
   
      messages.add(Message(
          isUser: false, message: response.text ?? '', date: DateTime.now()));
       notifyListeners();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void clearMessages() {
      messages.clear();
      notifyListeners();
    }
}