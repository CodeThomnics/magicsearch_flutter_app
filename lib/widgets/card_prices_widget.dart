import 'package:flutter/material.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:url_launcher/url_launcher.dart';

class CardPricesWidget extends StatelessWidget {
  final MagicCard card;

  const CardPricesWidget({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prices = card.prices;
    final purchase = card.purchaseUris;

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
            'Prices',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Chip(label: Text('USD: ${_fmt(prices.usd, prefix: '\$')}')),
              Chip(
                  label:
                      Text('USD Foil: ${_fmt(prices.usdFoil, prefix: '\$')}')),
              Chip(label: Text('EUR: ${_fmt(prices.eur, prefix: '€')}')),
              Chip(label: Text('TIX: ${_fmt(prices.tix)}')),
            ],
          ),
          if (purchase != null) ...[
            const SizedBox(height: 8),
            Text(
              'Buy / View on',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (purchase.tcgplayer != null)
                  TextButton.icon(
                    onPressed: () => _openUrl(purchase.tcgplayer),
                    icon: const Icon(Icons.shopping_cart, size: 18),
                    label: const Text('TCGplayer'),
                  ),
                if (purchase.cardmarket != null)
                  TextButton.icon(
                    onPressed: () => _openUrl(purchase.cardmarket),
                    icon: const Icon(Icons.store, size: 18),
                    label: const Text('Cardmarket'),
                  ),
                if (purchase.cardhoarder != null)
                  TextButton.icon(
                    onPressed: () => _openUrl(purchase.cardhoarder),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Cardhoarder'),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _fmt(dynamic v, {String prefix = ''}) {
    if (v == null) return '-';
    final s = v is String ? v : v.toString();
    if (s.isEmpty) return '-';
    return prefix + s;
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}