import 'package:electronics_market/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../widgets/texts/subtitle_text.dart';

class QuantityBottomSheetWidget extends StatelessWidget {
  const QuantityBottomSheetWidget({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: IconButton(
        //       onPressed: () {
        //         Navigator.of(context);
        //       },
        //       icon: const Icon(
        //         Icons.clear,
        //         color: Colors.red,
        //       ),
        //     ),
        //   ),
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  cartProvider.updateQuantity(
                    productId: productId,
                    newQuantity: index + 1,
                  );
                  Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubtitlesTextWidget(
                      label: "${index + 1}",
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
