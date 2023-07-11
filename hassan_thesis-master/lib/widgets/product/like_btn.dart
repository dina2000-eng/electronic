import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/like_products.dart';

class LikeButtonWidget extends StatefulWidget {
  final String productId;

  const LikeButtonWidget({
    super.key,
    required this.productId,
  });

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool _isLoading = false;
  bool isLiked = false;
  int likesCount = 0;

  @override
  void initState() {
    super.initState();

    // Call checkIfLiked after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfLiked();
      fetchLikes();
    });
  }

  Future<void> checkIfLiked({String? prodid, bool listen = false}) async {
    final authProv = Provider.of<AuthProvider>(context, listen: listen);
    final likesProvider = Provider.of<LikesProvider>(context, listen: listen);
    if (authProv.getToken == null) {
      return;
    }
    // # needed to check if it is on initialization or after unlike or like.
    bool liked = false;
    if (prodid == null) {
      liked = await likesProvider.checkIfLiked(
          productId: widget.productId, token: authProv.getToken!);
    } else {
      liked = await likesProvider.checkIfLiked(
          productId: prodid, token: authProv.getToken!);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      isLiked = liked;
    });
  }

  Future<void> fetchLikes() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final likesprov = Provider.of<LikesProvider>(context, listen: false);

    // Update the likesCount state once the response from the server is received
    int count = await likesprov.getLikesCount(
      productId: widget.productId,
      token: authProv.getToken!,
    );

    if (!mounted) {
      return;
    }
    setState(() {
      likesCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final likesProvider = Provider.of<LikesProvider>(context);
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.all(4.0),
            child: CircularProgressIndicator(),
          ) // Show loading spinner while waiting
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked
                        ? Icons.thumb_up_alt_rounded
                        : Icons
                            .thumb_up_alt_outlined, // Choose the right icon based on state
                  ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true; // Start loading
                    });

                    try {
                      // Use the appropriate method depending on the current state
                      if (isLiked) {
                        await likesProvider.unlikeProduct(
                          productId: widget.productId,
                          token: authProv.getToken!,
                        );
                        setState(() {
                          isLiked = false;
                        });
                        log("Unlike");
                      } else {
                        await likesProvider.likeProduct(
                          productId: widget.productId,
                          token: authProv.getToken!,
                        );
                        setState(() {
                          isLiked = true;
                        });
                      }
                      fetchLikes();
                      // await likesProvider.getLikesCount(
                      //   productId: widget.productId,
                      //   token: authProv.getToken!,
                      // );
                      // log("isLiked abovce checkIfLiked $isLiked");
                      // await checkIfLiked(prodid: widget.productId, listen: false);

                      // bool liked = await likesProvider.checkIfLiked(
                      //   productId: widget.productId,
                      //   token: authProv.getToken!,
                      // );

                      // setState(() {
                      //   isLiked = liked;
                      // });

                      // log("isLiked $isLiked");
                      // Switch the state if the operation was successful
                      // isLiked = !isLiked;
                    } catch (error) {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false; // Stop loading
                      });
                    }
                  },
                ),
                const Spacer(),
                Text('Likes: $likesCount'),
              ],
            ),
          );
  }
}
