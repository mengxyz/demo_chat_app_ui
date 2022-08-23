import 'package:chat_app_ui/message_widget.dart';

part 'message.g.dart';

class Message {
  final String uid;
  final String content;
  String createdAt;
  final bool read;
  final String roomId;
  final String senderId;
  final bool isMe;
  MessageState state;
  bool get isSending => state == MessageState.sending;
  bool get isSended => state == MessageState.sended;
  bool get isNothing => state == MessageState.nothing;

  String get sendTime {
    final dt = DateTime.parse(createdAt).toLocal();
    return "${dt.hour.toString().padLeft(2, "0")}:${dt.minute.toString().padLeft(2, "0")}";
  }

  Message(
    this.uid,
    this.content,
    this.createdAt,
    this.read,
    this.roomId,
    this.senderId,
    this.isMe, {
    this.state = MessageState.sending,
  });

  factory Message.fromJson(dynamic json) => _$MessageFromJson(json);

  Message copy() {
    return Message(
      uid,
      content,
      createdAt,
      read,
      roomId,
      senderId,
      isMe,
    );
  }
}
