import 'package:chat_app_ui/message/chat_room_widget_controller.dart';
import 'package:chat_app_ui/spacer_box.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class ChatRoomWidget<P, T> extends StatefulWidget {
  final ChatRoomWidgetController<P, T> controller;
  final ItemBuilder<T> itemBuilder;
  const ChatRoomWidget({
    Key? key,
    required this.controller,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  State<ChatRoomWidget> createState() => _ChatRoomWidgetState<P, T>();
}

class _ChatRoomWidgetState<P, T> extends State<ChatRoomWidget<P, T>> {
  listener() => setState(() => {});

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (t) {
        if (t.metrics.pixels > 0 && t.metrics.atEdge) {
          if (widget.controller.currentPage.nextPage == null ||
              widget.controller.pageState == PageState.error) {
            return false;
          }
          widget.controller.callNextPage();
        }
        return false;
      },
      child: Column(
        children: [
          if (widget.controller.pageState == PageState.loading) ...[
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: SizedBox(
                height: 24,
                child: Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          ],
          if (widget.controller.pageState == PageState.error) ...[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 24,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: widget.controller.refresh,
                        icon: const Icon(Icons.refresh),
                        label: Text("Refresh"),
                      ),
                      SpaceBox.s,
                      Text("Error"),
                    ],
                  ),
                ),
              ),
            )
          ],
          Expanded(
            child: ListView.builder(
              controller: widget.controller.scrollController,
              reverse: true,
              itemCount: widget.controller.items.length,
              itemBuilder: (context, index) {
                return widget.itemBuilder(
                  context,
                  widget.controller.items[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
