import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/providers/random_card_provider.dart';
import 'package:magicsearch_flutter_app/widgets/card_display_widget.dart';

class RandomCardScreen extends ConsumerWidget {
  const RandomCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomCard = ref.watch(randomCardProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) ref.invalidate(randomCardProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Random Card'),
        actions: [
          IconButton(
            tooltip: 'New random card',
            icon: const Icon(Icons.shuffle),
            onPressed: () => ref.invalidate(randomCardProvider),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: randomCard.when(
          data: (card) => SingleChildScrollView(
            key: ValueKey(card.id),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Center(child: CardDisplayWidget(card: card)),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text('Failed to load card', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('$error', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(randomCardProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: randomCard.hasValue
          ? FloatingActionButton.extended(
              onPressed: () => ref.invalidate(randomCardProvider),
              icon: const Icon(Icons.shuffle),
              label: const Text('New Card'),
            )
          : null,
      ),
    );
  }
}
