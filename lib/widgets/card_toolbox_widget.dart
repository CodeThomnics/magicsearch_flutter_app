import 'package:flutter/material.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:url_launcher/url_launcher.dart';

class CardToolboxWidget extends StatelessWidget {
  final MagicCard card;

  const CardToolboxWidget({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final related = card.relatedUris;
    // Direct Moxfield search for the card name
    final moxfieldSearchUrl =
      'https://www.moxfield.com/search?q=${Uri.encodeQueryComponent(card.name)}';

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Toolbox',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildToolLink(
                label: 'Moxfield',
                url: moxfieldSearchUrl,
                icon: Icons.search,
              ),
              _buildToolLink(
                label: 'Scryfall',
                url: card.scryfallUri,
                icon: Icons.auto_stories,
              ),
              if (_hasUrl(related?.edhrec))
                _buildToolLink(
                  label: 'EDHREC',
                  url: related!.edhrec,
                  icon: Icons.hub,
                ),
              if (_hasUrl(related?.gatherer))
                _buildToolLink(
                  label: 'Gatherer',
                  url: related!.gatherer!,
                  icon: Icons.library_books,
                ),
              if (_hasUrl(related?.tcgplayerInfiniteArticles))
                _buildToolLink(
                  label: 'Infinite Articles',
                  url: related!.tcgplayerInfiniteArticles,
                  icon: Icons.article,
                ),
              if (_hasUrl(related?.tcgplayerInfiniteDecks))
                _buildToolLink(
                  label: 'Infinite Decks',
                  url: related!.tcgplayerInfiniteDecks,
                  icon: Icons.style,
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _hasUrl(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  Widget _buildToolLink({
    required String label,
    required String url,
    required IconData icon,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _openUrl(url),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}