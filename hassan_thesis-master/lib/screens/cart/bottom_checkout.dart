import 'package:electronics_market/consts/app_color.dart';
import 'package:electronics_market/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/texts/subtitle_text.dart';
import '../../widgets/texts/title_text.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget(
      {super.key,
      required this.buttonText,
      required this.function,
      required this.amount});
  final String buttonText;
  final Function function;
  final double amount;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(width: 0.3, style: BorderStyle.solid),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                      child: TitlesTextWidget(
                        label:
                            "Total (${cartProvider.getCartItems.length} Products/${cartProvider.getQTY(productsProvider: productsProvider)}} Items)"
                                .toCurrencyFormat()!,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: FittedBox(
                      child: SubtitlesTextWidget(
                        label: "\$${amount.toStringAsFixed(2)}",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  function();
                },
                child: SubtitlesTextWidget(
                  label: buttonText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.ON_BOARDING_COLOR,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
