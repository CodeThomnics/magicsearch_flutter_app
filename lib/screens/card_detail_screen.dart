import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/providers/card_provider.dart';
import 'package:magicsearch_flutter_app/widgets/card_display_widget.dart';

class CardDetailScreen extends ConsumerWidget {
  final String cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardByIdProvider(cardId));

    return cardAsync.when(
      data: (card) => Scaffold(
        appBar: AppBar(title: Text(card.name)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: CardDisplayWidget(card: card, maxImageWidth: 360),
            ),
          ),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to load card details'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(cardByIdProvider(cardId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
