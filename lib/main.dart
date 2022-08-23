import 'package:chat_app_ui/chat_controller.dart';
import 'package:chat_app_ui/chat_room_widget.dart';
import 'package:chat_app_ui/message_widget.dart';
import 'package:chat_app_ui/reply_comment_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message/message.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => ChatController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chat App UI Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Provider.of<ChatController>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Expanded(
            child: ChatRoomWidget<int, Message>(
              controller:
                  Provider.of<ChatController>(context).chatRoomWidgetController,
              itemBuilder: (ctx, item) {
                return MessageWidget(
                  item: item,
                  onLongPresss: () {
                    Provider.of<ChatController>(context, listen: false)
                        .setReply(item);
                  },
                );
              },
            ),
          ),
          Consumer<ChatController>(
            builder: (context, v, child) => ReplyCommentInputWidget(
              controller: v.chatInputController,
              onSubmit: v.submit,
              replyMessage: v.replyMessage,
              removeReply: v.removeReply,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.small(
          onPressed:
              Provider.of<ChatController>(context, listen: false).sendRandom,
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
