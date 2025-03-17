import 'package:crypto_tracker_app/models/coins.dart';
import 'package:crypto_tracker_app/screens/coin_converter_screen.dart';
import 'package:crypto_tracker_app/screens/coin_details_screen.dart';
import 'package:crypto_tracker_app/screens/markets_screen.dart';
import 'package:crypto_tracker_app/screens/news_screen.dart';
import 'package:crypto_tracker_app/screens/onboarding.dart';
import 'package:crypto_tracker_app/screens/search_screen.dart';
import 'package:crypto_tracker_app/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => CryptoOnboarding(),
    ),
    GoRoute(
      path: '/markets',
      builder: (context, state) => MarketsScreen(),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => NewsScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => SearchScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      path: '/coinDetails',
      builder: (context, state) => CoinDetails(coin: state.extra as CoinModel),
    ),
    
  ],
);
