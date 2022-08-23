import 'package:flutter/material.dart';

import 'message/message.dart';

class ReplyCommentInputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onSubmit;
  final VoidCallback? removeReply;
  final Message? replyMessage;
  const ReplyCommentInputWidget({
    Key? key,
    this.controller,
    this.onSubmit,
    this.replyMessage,
    this.removeReply,
  }) : super(key: key);

  @override
  State<ReplyCommentInputWidget> createState() =>
      ReplyCommentInputWidgetState();
}

class ReplyCommentInputWidgetState extends State<ReplyCommentInputWidget> {
  _listener() => setState(() => {});

  @override
  void initState() {
    widget.controller?.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.replyMessage != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "reply: ${widget.replyMessage!.content}",
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.removeReply,
                      child: const Icon(
                        Icons.close,
                        size: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  maxLines: 3,
                  minLines: 1,
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Aa",
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              IconButton(
                splashRadius: 18,
                splashColor: Colors.transparent,
                onPressed: widget.controller?.text.isNotEmpty == true
                    ? widget.onSubmit
                    : null,
                icon: Icon(
                  Icons.send,
                  color: widget.controller?.text.isNotEmpty == true
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
