import 'package:electronics_market/models/order_display.dart';
import 'package:electronics_market/models/salesModel.dart';
import 'package:electronics_market/services/assets_manager.dart';
import 'package:electronics_market/widgets/empty_bag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/order_display_provider.dart';
import '../../providers/sales_propvider.dart';

class SalesScreen extends StatelessWidget {
  static const routeName = '/SalesScreenFree';

  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProv =
        Provider.of<SalesDisplayProvider>(context, listen: false);
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    return orderProv.sales.isEmpty
        ? EmptyBagWidget(
            imagePath: AssetsManager.orderBag,
            title: "You have no sales yet :'(",
            subtitle: "",
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Your Sales'),
            ),
            body: FutureBuilder(
              future: orderProv.fetchAndSetSales(token: authProv.getToken!),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    return const Center(child: Text('An error occurred!'));
                  } else {
                    return Consumer<SalesDisplayProvider>(
                      builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.sales.length,
                        itemBuilder: (ctx, i) =>
                            OrderWidget(orderData.sales[i]),
                      ),
                    );
                  }
                }
              },
            ),
          );
  }
}

class OrderWidget extends StatelessWidget {
  final SalesModel sale;

  const OrderWidget(this.sale, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:Text(sale.id.toString()),
        title: Text(sale.productName!),
        subtitle: Text('Quantity: ${sale.productQuantity.toString()}'),

        trailing: sale.totalPrice == null
            ? const Text("\$")
            : Text(
            '\$${double.parse(sale.totalPrice!).toStringAsFixed(2)}'),
      ),
    );
  }
}

