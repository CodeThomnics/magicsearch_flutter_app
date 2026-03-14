import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/providers/card_provider.dart';

class CardDetailScreen extends ConsumerWidget {
  final String cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardByIdProvider(cardId));

    return cardAsync.when(
      data: (card) => Scaffold(
        appBar: AppBar(title: Text(card.name)),
        body: Center(child: Text('Card details here')),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Failed to load card details')),
      ),
    );
  }
}
