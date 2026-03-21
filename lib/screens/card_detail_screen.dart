import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:magicsearch_flutter_app/providers/card_provider.dart';
import 'package:magicsearch_flutter_app/providers/card_search_provider.dart';
import 'package:magicsearch_flutter_app/widgets/card_display_widget.dart';

class CardDetailScreen extends ConsumerWidget {
  final String cardId;

  const CardDetailScreen({super.key, required this.cardId});

  void _searchByArtist(BuildContext context, WidgetRef ref, String artist) {
    ref.read(cardSearchQueryProvider.notifier).setQuery(artist);
    context.pushReplacement('/search');
  }

  Future<void> _shareCard(BuildContext context, String cardId, String cardName) async {
    final deepLink = Uri(
      scheme: 'magicsearch',
      host: 'card',
      pathSegments: [cardId],
    ).toString();

    final shareText = 'Check out $cardName on MagicSearch\n$deepLink';
    await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: cardName,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(cardByIdProvider(cardId));

    return cardAsync.when(
      data: (card) => Scaffold(
        appBar: AppBar(title: Text(card.name)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CardDisplayWidget(
                    card: card,
                    maxImageWidth: 360,
                    showInfo: false,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: FilledButton.icon(
                    onPressed: () => _shareCard(context, card.id, card.name),
                    icon: const Icon(Icons.share),
                    label: const Text('Share card'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: CardDisplayWidget(
                    card: card,
                    showImage: false,
                    onArtistTap: () => _searchByArtist(context, ref, card.artist),
                  ),
                ),
              ],
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
