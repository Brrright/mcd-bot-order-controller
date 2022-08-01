import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordercontroller/card_component/order_card.dart';
import 'package:ordercontroller/providers/manager.dart';

import '../providers/order.dart';

class CustomerPage extends ConsumerWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    // final orderController = ref.read(orderProviders
    //     .notifier); // READ - get the value (just once), .notifier allow us to get the
    UIManager UImanager = UIManager(ref.read); //passing ref.read into it 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        title: const Text(
          'McDonald Order Controller - Customer Page',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/manager');
        },
        child: const Icon(Icons.settings),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      UImanager.addVIPOrder();
                    },
                    child: const Text(
                      'VIP Order',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      UImanager.addNormalOrder();
                    },
                    child: const Text(
                      'Normal Order',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const orderAreaTitle(),
            const SizedBox(
              height: 30.0,
            ),
            const orderAreaContent()
          ],
        ),
      ),
    );
  }
}

class orderAreaContent extends ConsumerWidget {
  const orderAreaContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    // final orders = ref.watch(orderProviders);
    final vipOrders = ref.watch(
        vipOrdersPendingProviders); // every provider, need '.WATCH' before used
    final normalOrders = ref.watch(normalOrdersPendingProviders);
    final completedOrders = ref.watch(completedOrdersProviders);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        pendingArea(vipOrders: vipOrders, normalOrders: normalOrders),
        completedArea(completedOrders: completedOrders),
      ],
    );
  }
}

class completedArea extends StatelessWidget {
  const completedArea({
    Key? key,
    required this.completedOrders,
  }) : super(key: key);

  final Iterable<Order> completedOrders;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: completedOrders
                .map((order) => OrderCard(order: order))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class pendingArea extends StatelessWidget {
  const pendingArea({
    Key? key,
    required this.vipOrders,
    required this.normalOrders,
  }) : super(key: key);

  final Iterable<Order> vipOrders;
  final Iterable<Order> normalOrders;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children:
                vipOrders.map((order) => OrderCard(order: order)).toList(),
          ),
          Column(
            children:
                normalOrders.map((order) => OrderCard(order: order)).toList(),
          )
        ],
      ),
    );
  }
}

class orderAreaTitle extends StatelessWidget {
  const orderAreaTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
      color: Colors.yellow[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'PENDING',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'COMPLETED',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
