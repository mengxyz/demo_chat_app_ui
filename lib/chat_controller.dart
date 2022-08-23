import 'package:chat_app_ui/message/chat_room_widget_controller.dart';
import 'package:chat_app_ui/message_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'message/message.dart';

class ChatController extends ChangeNotifier {
  final chatInputController = TextEditingController();

  final chatRoomWidgetController = ChatRoomWidgetController<int, Message>(
    initialPage: 1,
    diffUtils: (p0, p1) => p0.uid == p1.uid,
    sort: (a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
  );

  Message? replyMessage;
  List<Message> messages = [];
  setReply(Message reply) {
    replyMessage = reply;
    notifyListeners();
  }

  removeReply() {
    replyMessage = null;
    notifyListeners();
  }

  sendRandom() {
    final newMessage = Message(
      const Uuid().v4(),
      "Random ${DateTime.now()}",
      DateTime.now().toUtc().toIso8601String(),
      false,
      "",
      "",
      false,
      state: MessageState.nothing,
    );
    chatRoomWidgetController.add([newMessage]);
  }

  Future<void> fakePaginate(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    final newMessages = List.generate(50, (i) => i)
        .map((i) => Message(
              const Uuid().v4(),
              "Random ${DateTime.now()}",
              DateTime.now().toUtc().toIso8601String(),
              false,
              "",
              "",
              false,
              state: MessageState.nothing,
            ))
        .toList();
    if (page == 3) {
      chatRoomWidgetController.addLatestPage(
        newMessages,
      );
      // chatRoomWidgetController.pageError(Exception("Net work Too slow"));
      return;
    }
    chatRoomWidgetController.addPage(newMessages, page += 1);
  }

  Future<void> asyncSending(Message msg) async {
    await Future.delayed(const Duration(seconds: 3));
    final mustbeUpdate = msg.copy();
    mustbeUpdate.state = MessageState.sended;
    mustbeUpdate.createdAt = DateTime.now().toUtc().toIso8601String();
    chatRoomWidgetController.updateAtAndSort(
      ((p0) => p0.uid == msg.uid),
      mustbeUpdate,
    );
  }

  submit() {
    final newMessage = Message(
      const Uuid().v4(),
      chatInputController.text,
      DateTime.now().toUtc().toIso8601String(),
      false,
      "",
      "",
      true,
      state: MessageState.sending,
    );
    chatRoomWidgetController.add([newMessage]);
    chatInputController.text = "";
    asyncSending(newMessage);
  }

  init() {
    chatRoomWidgetController.fetchListener(fakePaginate);
  }
}
