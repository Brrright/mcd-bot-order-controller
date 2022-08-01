import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordercontroller/providers/bot.dart';
import 'package:ordercontroller/card_component/bot_card.dart';
import 'package:ordercontroller/providers/manager.dart';

class ManagerPage extends ConsumerWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final bots = ref.watch(botProviders);
    // final botController = ref.read(botProviders.notifier);
    UIManager UImanager = UIManager(ref.read);
    return Scaffold(
      appBar: AppBar(
        title: const Text('McDonald Order Controller - Manager Page'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    UImanager.addBot();
                  },
                  child: const Text(
                    '+ Bot',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    UImanager.deleteBot();
                  },
                  child: const Text(
                    '- Bot',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: bots.map((bot) => BotCard(bot: bot)).toList(),
          )
        ]),
      ),
    );
  }
}
