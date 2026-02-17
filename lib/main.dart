import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_page.dart';

void main() {
  // runApp  is the starts the flutter app
  runApp(MyApp());
}

//create go router
// the '_' is indicating private virable
final GoRouter _rounter = GoRouter(
  initialLocation: '/', // this is the first screen when app starts
  routes: [GoRoute(path: '/', builder: (context, state) => LoginScreen())],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _rounter);
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
// }
