import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordercontroller/pages/customerPage.dart';
import 'package:ordercontroller/pages/managerPage.dart';
import 'package:ordercontroller/providers/manager.dart';

void main() => runApp(const ProviderScope(
    //must use ProviderScope() on the root
    child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(Manager);
    return MaterialApp(
      initialRoute: '/customer',
      routes: {
        '/customer': (context) => CustomerPage(),
        '/manager': (context) => ManagerPage(),
      },
    );
  }
}
