import 'package:flutter/material.dart';

import '../providers/bot.dart';

//data often changed from time to time, how to reflect on specific card?
// use stateful? or statefulConsumer?
// how to update specific object ? access them via provider and filter by ID?
// quite blur now

class BotCard extends StatelessWidget {
  final Bot bot;

  BotCard({required this.bot});
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'BOT - ${bot.botID}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 6.0),
              Row(
                children: [
                  Text(
                    bot.botStatus,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '  [order - ${bot.botWorkingOn}]',
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
