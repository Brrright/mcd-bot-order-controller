import 'dart:async'; // for Timer
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bot {
  int botID;
  String botStatus;
  int? botWorkingOn;
  Timer? timer;

  // constructor
  Bot({
    required this.botID,
    required this.botStatus,
    this.botWorkingOn,
    this.timer,
  });
}

class BotController extends StateNotifier<List<Bot>> {
  BotController() : super([]); //passing this.read to the list

  // setters
  newBot() {
    final newBot = Bot(
      botID: state.length + 1,
      botStatus: 'IDLE',
      botWorkingOn: null,
      timer: null,
    );
    state = [...state, newBot]; // append bot into the bot list
  }

  updateBotStatus(availableBotID, status, orderID, Timer timerReceived) {
    for (int i = 0; i < state.length; i++) {
      if (availableBotID == state[i].botID) {
        state[i].botStatus = status;
        state[i].botWorkingOn = orderID;
        if (status == 'working') {
          state[i].timer = timerReceived;
          state = [...state];
        }
        return;
      }
    }
  }

  resetBotStatus(botID) {
    // print('reseting');
    for (int i = 0; i < state.length; i++) {
      if (botID == state[i].botID) {
        state[i].botStatus = "IDLE";
        state[i].botWorkingOn = null;
        state[i].timer = null;
        state = [...state];
      }
    }
  }

  void destroyBot(receivedBot) {
    final botFromState =
        state.firstWhere((element) => element.botID == receivedBot.botID);
    if (botFromState.timer != null) {
      botFromState.timer!.cancel();
    }
    final orderIDProcessing = botFromState.botWorkingOn;

    state.remove(receivedBot);
    state = [...state];
    // print(state);
  }

  // getters
  List<Bot> get getIdleBots {
    return state.where((element) => element.botStatus == 'IDLE').toList();
  }

  getFirstAvailableBot() {
    var IDLEBots = getIdleBots;
    if (IDLEBots.isNotEmpty) {
      return IDLEBots.first;
    } else {
      return null;
    }
  }

  getLastBot() {
    if (state.isNotEmpty) {
      return state.last;
    } else {
      return null;
    }
  }

  getLastBotStatus() {
    if (state.isNotEmpty) {
      return state.last.botStatus;
    } else {
      return null;
    }
  }
}

final botProviders = StateNotifierProvider<BotController, List<Bot>>((ref) {
  return BotController();
});
