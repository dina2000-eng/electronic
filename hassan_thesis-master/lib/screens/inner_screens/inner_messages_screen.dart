import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';

class InnerMessageScreen extends StatefulWidget {
  final int secondSideId;
  final String sellerName;

  const InnerMessageScreen({
    Key? key,
    required this.secondSideId,
    required this.sellerName,
  }) : super(key: key);

  @override
  State<InnerMessageScreen> createState() => _InnerMessageScreenState();
}

class _InnerMessageScreenState extends State<InnerMessageScreen> {
  late Future _getMessagesFuture;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isFirstLoading = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getMessagesFuture = _fetchMessages();
  }

  Future _fetchMessages() {
    return Provider.of<MessageProvider>(context, listen: false).fetchMessages(
      secondSide: widget.secondSideId,
      token: Provider.of<AuthProvider>(context, listen: false).getToken!,
    );
  }

  String formatDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr).toLocal();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Future _sendMessage() async {
    setState(() {
      isFirstLoading = false;
      isLoading = true;
    });
    await Provider.of<MessageProvider>(context, listen: false).sendMessage(
      secondSide: widget.secondSideId,
      message: _controller.text,
      token: Provider.of<AuthProvider>(context, listen: false).getToken!,
    );
    _controller.clear();
    setState(() {
      _getMessagesFuture = _fetchMessages();
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.sellerName}"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _getMessagesFuture,
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          isFirstLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (dataSnapshot.error != null) {
                          return Center(
                              child: Text(
                                  'An error occurred! ${dataSnapshot.error}'));
                        } else {
                          return Consumer<MessageProvider>(
                            builder: (ctx, messageData, child) =>
                                ListView.builder(
                              controller: _scrollController,
                              itemCount: messageData.items.length,
                              itemBuilder: (ctx, i) {
                                var message = messageData.items[i];
                                bool isMe = message.me == message.firstSide;
                                String initialLetter =
                                    isMe ? message.me : message.secondUser;
                                return Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    if (isMe)
                                      CircleAvatar(
                                        child: FittedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(initialLetter),
                                          ),
                                        ),
                                      ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? Theme.of(context).cardColor
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 16,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message.message,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            formatDate(message.createdAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!isMe)
                                      CircleAvatar(
                                        child: FittedBox(
                                            child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(initialLetter),
                                        )),
                                      ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Send a message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        await _sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
