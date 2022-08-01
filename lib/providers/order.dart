import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class Order {
  int orderID;
  String orderType;
  String orderStatus;

//constructor
  Order({
    required this.orderID,
    required this.orderType,
    this.orderStatus = 'pending',
  });
}

// StateNotifier
class OrderController extends StateNotifier<List<Order>> {
  // initialize the list to an empty list
  // empty list to super (stateNotifier), so we can use state (?)
  OrderController() : super([]);

  _newOrder(String type) {
    final newOrder = Order(
      orderID: state.length + 1,
      orderType: type,
    );
    state = [
      ...state, // previous order
      newOrder, // append new order
    ];
  }

  newNormalOrder() {
    _newOrder('normal');
  }

  newVipOrder() {
    _newOrder('vip');
  }

  // setters
  void updateOrderToComplete(int pendingOrderID) {
    for (int i = 0; i < state.length; i++) {
      if (pendingOrderID == state[i].orderID) {
        state[i].orderStatus = 'complete';
        state = [...state];
        return;
      }
    }
  }

  void updateOrderToProcessing(int pendingOrderID) {
    for (int i = 0; i < state.length; i++) {
      if (pendingOrderID == state[i].orderID) {
        state[i].orderStatus = 'processing';
        state = [...state];
        return;
      }
    }
  }

  void updateOrderToPending(int pendingOrderID) {
    for (int i = 0; i < state.length; i++) {
      if (pendingOrderID == state[i].orderID) {
        state[i].orderStatus = 'pending';
        state = [...state];
        return;
      }
    }
  }

// getters
// - for inner use
  List<Order> get getVipOrders {
    return state.where((element) => element.orderType == 'vip').toList();
  }

  List<Order> get getNormalOrders {
    return state.where((element) => element.orderType == 'normal').toList();
  }

  List<Order> get getCompletedOrders {
    return state.where((element) => element.orderStatus == 'complete').toList();
  }

  getPendingOrder() {
    var vipOrder = getVipOrders
        .firstWhereOrNull((element) => element.orderStatus == 'pending');
    if (vipOrder != null) {
      return vipOrder;
    } else {
      final normalOrder = getNormalOrders
          .firstWhereOrNull((element) => element.orderStatus == 'pending');
      if (normalOrder != null) {
        return normalOrder;
      }
    }
    return null;
  }
}

// "StateNotifierProvider"
final orderProviders =
    StateNotifierProvider<OrderController, List<Order>>((ref) {
  // state notifier provider receive the ordercontrolller class and the list of order
  // pass the ordercontroller class, and the list of order
  return OrderController(); // returning the controller
});

// --"Provider"--
// completed orders
final completedOrdersProviders = Provider((ref) {
  final orders = ref.watch(orderProviders);
  return orders.where((order) => order.orderStatus == 'complete');
});

// vip orders
final vipOrdersProviders = Provider((ref) {
  final orders = ref.watch(orderProviders);
  return orders.where((order) => order.orderType == 'vip');
});

final vipOrdersPendingProviders = Provider((ref) {
  final orders = ref.watch(orderProviders);
  return orders.where(
      (order) => order.orderType == 'vip' && order.orderStatus != 'complete');
});

// normal orders
final normalOrdersProviders = Provider((ref) {
  final orders = ref.watch(orderProviders);
  return orders.where((order) => order.orderType == 'normal');
});

final normalOrdersPendingProviders = Provider((ref) {
  final orders = ref.watch(orderProviders);
  return orders.where((order) =>
      order.orderType == 'normal' && order.orderStatus != 'complete');
});
