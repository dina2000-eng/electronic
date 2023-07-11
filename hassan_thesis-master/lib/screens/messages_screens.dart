// chat_screen.dart

import 'dart:developer';

import 'package:electronics_market/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message_model.dart';
import '../providers/auth_provider.dart';
import '../providers/message_provider.dart';
import '../services/assets_manager.dart';
import 'inner_screens/inner_messages_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Future? _chatsFuture;

  Future _fetchChats() {
    return Provider.of<MessageProvider>(context, listen: false).fetchChats(
      token: Provider.of<AuthProvider>(context, listen: false).getToken!,
    );
  }

  @override
  void initState() {
    super.initState();
    _chatsFuture = _fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const TitlesTextWidget(label: "Messages"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _chatsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              // Error handling...
              return Center(
                child: SelectableText('An error occurred! ${snapshot.error}'),
              );
            } else {
              List<Chat> chats = Provider.of<MessageProvider>(context).chats;
              return chats.isEmpty
                  ? const Center(
                      child: TitlesTextWidget(
                        label: "No messages yet!",
                        fontSize: 30,
                      ),
                    )
                  : ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (ctx, index) => ListTile(
                        leading: CircleAvatar(
                          // You can put an image or text in the CircleAvatar, I am using initials as an example.
                          child: Text(chats[index].name[0]),
                        ),
                        title: Text(chats[index].name),
                        trailing: Icon(Icons
                            .arrow_forward_ios), // The icon at the end of ListTile
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InnerMessageScreen(
                                secondSideId: chats[index].id,
                                sellerName: chats[index].name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
            }
          }
        },
      ),
    );
  }
}



// import 'package:electronics_market/widgets/texts/subtitle_text.dart';
// import 'package:electronics_market/widgets/texts/title_text.dart';
// import 'package:flutter/material.dart';

// import '../services/assets_manager.dart';
// import '../widgets/app_name_text.dart';
// import '../widgets/profile_image.dart';
// import 'inner_screens/inner_messages_screen.dart';

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({super.key});

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: const AppNameTextWidget(
//           fontSize: 18,
//         ),
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
//           child: Image.asset(
//             AssetsManager.shoppingCart,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: ListView.builder(
//                   itemCount: 20,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         // Navigator.pushNamed(context, ChatScreen.routeName);
//                       },
//                       child: const ListTile(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 3, horizontal: 10),
//                         leading: ProfileImageWidget(radius: 18),
//                         title: TitlesTextWidget(label: "Name"),
//                         subtitle: SubtitlesTextWidget(label: "Text message"),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 20,
//                         ),
//                       ),
//                     );
//                   }))
//         ],
//       ),
//     );
//   }
// }
