import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordercontroller/providers/order.dart';
import 'package:ordercontroller/providers/bot.dart';

class UIManager {
  final Reader read;
  UIManager(this.read);

  OrderController get orderController => read(orderProviders.notifier);
  BotController get botController {
    return read(botProviders.notifier);
  } // longer way, same as above

  addNormalOrder() {
    orderController.newNormalOrder();
  }

  addVIPOrder() {
    orderController.newVipOrder();
  }

  addBot() {
    botController.newBot();
  }

  deleteBot() {
    final lastBot = botController.getLastBot();

    // if no bot, do nothing
    if (lastBot == null) {
      return;
    } else {
      String statusOfLastBot = lastBot.botStatus;

      // if bot is idle (direct destroy bot)
      if (statusOfLastBot == 'IDLE') {
        botController.destroyBot(lastBot);
      }
      // if bot is working
      final orderIDWorkingOn = lastBot.botWorkingOn;
      if (lastBot.botWorkingOn == null) {
        return;
      }
      if (statusOfLastBot == 'working') {
        botController.destroyBot(lastBot);
        orderController.updateOrderToPending(orderIDWorkingOn);
        return;
      }
    }
  }
}

processOrder(OrderController orderController, BotController botController) {
  // print("invoked!");
  final pendingOrder = orderController.getPendingOrder();

  if (pendingOrder != null) {
    final orderID = pendingOrder.orderID;
    final availableBot = botController.getIdleBots;
    if (availableBot.isNotEmpty) {
      final chosenBot = availableBot.first;
      final botID = chosenBot.botID;

      // update both bot and order status
      final constructTimer = Timer(const Duration(seconds: 10), () {
        orderController.updateOrderToComplete(orderID);
        botController.resetBotStatus(botID);
      });
      botController.updateBotStatus(botID, 'working', orderID, constructTimer);
      orderController.updateOrderToProcessing(orderID);
    }
  }
  return;
}

// class _FakeState {
//   final int id;
//   final bool isVip;

//   _FakeState(this.id, this.isVip);
// }

// final fakeStateProvider = Provider<_FakeState>((ref) {
//   return _FakeState(1, true);
// });

final Manager = Provider((ref) {
  final orderController = ref.read(orderProviders.notifier);
  final botController = ref.read(botProviders.notifier);
  // final state = ref.watch(fakeStateProvider.select((value) => value.isVip));

  ref.listen(
      orderProviders, (_, _1) => processOrder(orderController, botController));
  ref.listen(
      botProviders, (_, _1) => processOrder(orderController, botController));
});

//listen will not rerun entire provider's code, but watch does
