import 'package:flutter/material.dart';

import '../providers/order.dart';

class OrderCard extends StatelessWidget {
  final Order order; // order object

  const OrderCard({
    Key? key,
    required this.order, // need to pass the order object into OrderCard(orderObject)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '[${order.orderType}] order - ${order.orderID}',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Text(order.orderStatus)
      ]),
    );
  }
}
