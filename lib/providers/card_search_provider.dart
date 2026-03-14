import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:magicsearch_flutter_app/providers/dio_provider.dart';

class CardSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;

  void clear() => state = '';
}

/// Holds the current search query. Empty string means no search has been made.
final cardSearchQueryProvider =
    NotifierProvider<CardSearchQueryNotifier, String>(CardSearchQueryNotifier.new);

/// Represents a search result: either a single exact card or a list of matches.
class CardSearchResult {
  final MagicCard? exactCard;
  final List<MagicCard> cards;

  CardSearchResult.exact(MagicCard card)
      : exactCard = card,
        cards = const [];

  CardSearchResult.multiple(this.cards) : exactCard = null;

  bool get isExact => exactCard != null;
}

/// Searches for cards by name.
/// First tries an exact/fuzzy name match; if ambiguous or not found falls back
/// to a full-text search returning a list.
final cardSearchProvider = FutureProvider<CardSearchResult?>((ref) async {
  final dio = ref.watch(dioProvider);
  final query = ref.watch(cardSearchQueryProvider);
  if (query.trim().isEmpty) return null;

  // 1. Try exact/fuzzy named match.
  try {
    final response = await dio.get(
      '/cards/named',
      queryParameters: {'fuzzy': query.trim()},
    );
    try {
      return CardSearchResult.exact(MagicCard.fromJson(response.data));
    } catch (e, stack) {
      debugPrint('[CardSearch] JSON parse error (named): $e');
      debugPrintStack(label: '[CardSearch] Stack trace', stackTrace: stack);
      rethrow;
    }
  } on DioException catch (e) {
    if (e.response?.statusCode != 404) rethrow;
  }

  // 2. Fall back to full search.
  try {
    final response = await dio.get(
      '/cards/search',
      queryParameters: {'q': query.trim(), 'order': 'name', 'unique': 'cards'},
    );
    try {
      final data = response.data['data'] as List<dynamic>;
      final cards = data.map((c) => MagicCard.fromJson(c as Map<String, dynamic>)).toList();
      return CardSearchResult.multiple(cards);
    } catch (e, stack) {
      debugPrint('[CardSearch] JSON parse error (search): $e');
      debugPrintStack(label: '[CardSearch] Stack trace', stackTrace: stack);
      rethrow;
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      throw Exception('No cards found for "${query.trim()}"');
    }
    rethrow;
  }
});
