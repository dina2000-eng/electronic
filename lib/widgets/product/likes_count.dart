// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../providers/auth_provider.dart';
// import '../../providers/like_products.dart';

// class LikesCount extends StatefulWidget {
//   final String productId;

//   const LikesCount({required this.productId});

//   @override
//   State<LikesCount> createState() => _LikesCountState();
// }

// class _LikesCountState extends State<LikesCount> {
//   int likesCount = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Call fetchLikes after the first frame is rendered
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchLikes();
//     });
//   }

//   Future<void> fetchLikes() async {
//     final authProv = Provider.of<AuthProvider>(context, listen: false);
//     final likesprov = Provider.of<LikesProvider>(context, listen: false);

//     // Update the likesCount state once the response from the server is received
//     int count = await likesprov.getLikesCount(
//       productId: widget.productId,
//       token: authProv.getToken!,
//     );

//     setState(() {
//       likesCount = count;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final authProv = Provider.of<AuthProvider>(context);
//     // final likesprov = Provider.of<LikesProvider>(context);
//     return Text('Likes: $likesCount');
//   }
// }
