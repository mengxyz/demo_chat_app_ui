import 'package:flutter/material.dart';

import 'message/message.dart';
import 'spacer_box.dart';

enum MessageState {
  nothing,
  sending,
  sended;
}

class MessageWidget extends StatelessWidget {
  final Message item;
  final MessageState state;
  final VoidCallback? onLongPresss;
  const MessageWidget({
    Key? key,
    required this.item,
    this.state = MessageState.nothing,
    this.onLongPresss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPresss,
      child: content(context),
    );
  }

  Align content(BuildContext context) {
    return Align(
      alignment: item.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (item.isMe) ...[
            sendTime(context),
          ],
          SpaceBox.s,
          Flexible(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              color: item.isMe
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.content,
                  style: TextStyle(
                    color: item.isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          if (!item.isMe) ...[
            sendTime(context),
            SpaceBox.s,
          ],
          if (!item.isNothing) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(
                item.isSending
                    ? Icons.circle_outlined
                    : Icons.check_circle_outline,
                size: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
          SpaceBox.s,
        ],
      ),
    );
  }

  Text sendTime(BuildContext context) {
    return Text(
      item.sendTime,
      style:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }
}
