import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/screens/card_search_screen.dart';
import 'package:magicsearch_flutter_app/screens/home_screen.dart';
import 'package:magicsearch_flutter_app/screens/random_card_screen.dart';
import 'package:magicsearch_flutter_app/screens/card_detail_screen.dart';
// dart:async not required here

void main() {
  runApp(const ProviderScope(child: MagicSearchApp()));
}

final _navigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _navigatorKey,
  redirect: (context, state) {
    final uri = state.uri;

    // Supports deep links like:
    // magicsearch://card/<id>
    // magicsearch:///card/<id>
    if (uri.scheme == 'magicsearch') {
      final hostSegments = uri.host.isNotEmpty ? [uri.host] : <String>[];
      final allSegments = [...hostSegments, ...uri.pathSegments];

      if (allSegments.length >= 2 && allSegments.first == 'card') {
        final cardId = allSegments[1];
        if (cardId.isNotEmpty) {
          return '/card/$cardId';
        }
      }
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return ConnectivityPopupGate(
          navigatorKey: _navigatorKey,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: _router,
    );
  }
}

class ConnectivityPopupGate extends HookWidget {
  const ConnectivityPopupGate({
    required this.child,
    required this.navigatorKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final connectivity = useMemoized(() => Connectivity(), const []);
    final hasShown = useRef(false);

    useEffect(() {
      void handleConnectivityResults(List<ConnectivityResult> results) {
        final isOffline =
            results.isEmpty ||
            results.every((r) => r == ConnectivityResult.none);

        if (isOffline && !hasShown.value) {
          hasShown.value = true;
          final navContext = navigatorKey.currentContext;
          if (navContext == null || !navContext.mounted) return;
          ScaffoldMessenger.of(navContext).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text('You are offline.', style: TextStyle(color: Colors.white)),
                ],
              ),
              duration: Duration(days: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (!isOffline) {
          hasShown.value = false;
          final navContext = navigatorKey.currentContext;
          if (navContext != null && navContext.mounted) {
            ScaffoldMessenger.of(navContext).hideCurrentSnackBar();
          }
        }
      }

      // Check current connectivity immediately on mount, since
      // onConnectivityChanged only fires on changes and won't catch
      // an already-offline state at startup.
      connectivity.checkConnectivity().then(handleConnectivityResults);

      final subscription = connectivity.onConnectivityChanged.listen(
        handleConnectivityResults,
      );

      return subscription.cancel;
    }, [connectivity]);

    return child;
  }
}
