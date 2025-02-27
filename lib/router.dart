import 'package:crypto_tracker_app/screens/markets_screen.dart';
import 'package:crypto_tracker_app/screens/onboarding.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => CryptoOnboarding(),
    ),
    GoRoute(path: '/markets', 
    builder: (context, state) => MarketsScreen(),
    ),
  ],
);
