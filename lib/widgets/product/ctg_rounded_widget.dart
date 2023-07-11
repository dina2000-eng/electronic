import 'package:electronics_market/services/assets_manager.dart';
import 'package:flutter/material.dart';

import '../../screens/search_screen.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget(
      {super.key, required this.id, required this.name});

  final String id, name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, SearchScreen.routeName, arguments: id);
        Navigator.pushNamed(
          context,
          SearchScreen.routeName,
          arguments: {
            'id': id,
            "name": name,
            // Add more arguments here
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          // color: Theme.of(context).cardColor,
          child: Stack(
            children: [
              Image.asset(
                AssetsManager.elec,
                height: double.infinity,
                width: double.infinity,
              ),
              GridTile(
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
