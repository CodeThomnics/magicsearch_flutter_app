import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/screens/card_search_screen.dart';
import 'package:magicsearch_flutter_app/screens/home_screen.dart';
import 'package:magicsearch_flutter_app/screens/random_card_screen.dart';
import 'package:magicsearch_flutter_app/screens/card_detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: MagicSearchApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/random',
      builder: (context, state) => const RandomCardScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const CardSearchScreen(),
    ),
    GoRoute(
      path: '/card/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CardDetailScreen(cardId: id);
      },
    ),
  ],
);

class MagicSearchApp extends StatelessWidget {
  const MagicSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Magicsearch App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFBB86FC),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
          backgroundColor: Color(0xFFF3E5F5),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C27B0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
          backgroundColor: Color(0xFF1A0033),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
