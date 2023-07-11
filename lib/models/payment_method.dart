import 'package:flutter/material.dart';

class PaymentMethodsModel with ChangeNotifier {
  final String title;
  final IconData iconData;

  PaymentMethodsModel({
    required this.title,
    required this.iconData,
  });
}

List<PaymentMethodsModel> paymentsMehtodsList = [
  PaymentMethodsModel(
    title: "Master card, VISA",
    iconData: Icons.payment,
  ),
  PaymentMethodsModel(
    title: "Cash on delivery",
    iconData: Icons.payments_rounded,
  ),
];
