import 'package:electronics_market/models/order_display.dart';
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
    return orderProv.orders.isEmpty
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
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderWidget(orderData.orders[i]),
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
  final OrderDisplayModel order;

  const OrderWidget(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('Sale ${order.id}/Total Price:${order.totalPrice}\$'),
        children: order.products.map((prod) {
          return ListTile(
            leading: Image.network(prod.image),
            title: Text(prod.name),
            subtitle: Text('Quantity: ${prod.quantityOfProduct}'),
            // trailing: Text('\$${prod.price.toStringAsFixed(2)}'),
            trailing: prod.priceOfSellingProduct == null
                ? const Text("\$")
                : Text(
                    '\$${double.parse(prod.priceOfSellingProduct!).toStringAsFixed(2)}'),
          );
        }).toList(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// import '../../../../widgets/go_back_widget.dart';
// import '../../../../widgets/texts/title_text.dart';
// import 'orders_widget.dart';

// class OrdersScreenFree extends StatelessWidget {
//   static const routeName = '/OrdersScreenFree';

//   const OrdersScreenFree({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const TitlesTextWidget(label: 'Orders (14)'),
//         leading: const GoBackWidget(),
//       ),
//       body: ListView.builder(
//         itemCount: 12,
//         itemBuilder: (BuildContext ctx, int index) {
//           return const OrdersWidgetFree();
//         },
//       ),
//     );
//   }
// }
