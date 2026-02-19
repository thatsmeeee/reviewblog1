import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'blog_page.dart';
import 'test_life_cycle.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

//create go router
// the '_' is indicating private virable
final GoRouter _rounter = GoRouter(
  initialLocation: '/blog', // this is the first screen when app starts
  routes: [
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
    GoRoute(path: '/blog', builder: (context, state) => const BlogPage()),
    GoRoute(
      path: '/lifecycle',
      builder: (context, state) => const TestLifecyclePage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _rounter);
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
// }
