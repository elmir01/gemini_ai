import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:test_ai/management/flutter_management.dart';
import 'package:test_ai/model/message.dart';
import 'package:test_ai/widgets/message_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
 

  @override
 void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(homeViewModel).userControllor.addListener(() {
      ref
          .watch(homeViewModel)
          .scrollToBottom(ref.watch(homeViewModel).userControllor);
    });
  }

  @override
  void dispose() {
    ref.watch(homeViewModel).userControllor.dispose();
    ref.watch(homeViewModel).scrollController.dispose();
    super.dispose();
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
            onPressed: ref.read(homeViewModel).clearMessages,
            icon: Icon(
              Icons.restore,
              size: 35.sp,
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
                  controller: ref.watch(homeViewModel).scrollController,
                  itemCount: ref.watch(homeViewModel).messages.length,
                  itemBuilder: (context, index) {
                    final message = ref.watch(homeViewModel).messages[index];
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
                  padding:  EdgeInsets.all(8.sp),
                  child: TextFormField(
                    controller: ref.watch(homeViewModel).userControllor,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.sp),
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
                padding:  EdgeInsets.all(15.sp),
                child: IconButton(
                  onPressed: () {
                    ref.read(homeViewModel).sendMessage();
                  },
                  icon: Icon(Icons.send),
                  iconSize: 30.sp,
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
