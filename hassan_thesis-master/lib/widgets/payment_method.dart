import 'package:flutter/material.dart';
import 'rounded_icon_btn.dart';
import 'texts/subtitle_text.dart';

class PaymentMethodCart extends StatelessWidget {
  const PaymentMethodCart({
    Key? key,
    required this.title,
    required this.leadingIcon,
    required this.function,
    required this.isChosen,
  }) : super(key: key);

  final String title;
  final IconData leadingIcon;
  final Function function;
  final bool isChosen;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {
        function();
      },
      child: Card(
        color: isChosen ? Colors.lightBlue : Colors.grey,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: Icon(
                  leadingIcon,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            SubtitlesTextWidget(
              label: title,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            !isChosen
                ? const SizedBox.shrink()
                : const RoundedIconButton(
                    function: null,
                    icon: Icons.check_box,
                    iconColor: Colors.green,
                  ),

            // CircleAvatar(
            //   radius: 10,
            //   child: CircleAvatar(
            //     radius: 5,
            //     backgroundColor: Utils(context).color,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
