import 'package:go_router/go_router.dart';

import 'presentation/main_page.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'main',
          builder: (_, __) => const MainPage(),
        ),
      ],
    );
  }
}
