import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';
import 'screens/create_contract_screen.dart';
import 'screens/update_contract_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema CAAISA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/create': (context) => const CreateContractScreen(),
        '/update': (context) => const UpdateContractScreen(),
      },
    );
  }
}
