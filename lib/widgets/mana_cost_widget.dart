import 'package:flutter/material.dart';
import 'cached_svg_picture.dart';
 

/// Widget that displays Magic: The Gathering mana costs using Scryfall's SVG symbols.
///
/// Parses mana cost strings like `{2}{B}{B}` and displays the corresponding
/// mana symbols from Scryfall's CDN.
class ManaCostWidget extends StatelessWidget {
  final String manaCost;
  final double symbolSize;

  const ManaCostWidget({
    super.key,
    required this.manaCost,
    this.symbolSize = 20.0,
  });

  /// Parses a mana cost string and returns a list of symbol codes.
  ///
  /// Example: `{2}{B}{B}` returns `['2', 'B', 'B']`
  static List<String> parseManaCost(String manaCost) {
    final regex = RegExp(r'\{([^}]+)\}');
    return regex.allMatches(manaCost).map((m) => m.group(1)!).toList();
  }

  /// Converts a mana symbol code to its Scryfall SVG URL.
  ///
  /// Handles special cases like hybrid mana (W/U), Phyrexian mana (W/P), etc.
  static String getSymbolUrl(String symbol) {
    // Scryfall CDN uses symbols without slashes for hybrid mana
    // e.g., {W/U} becomes WU.svg, {2/W} becomes 2W.svg
    final normalizedSymbol = symbol.replaceAll('/', '');
    return 'https://svgs.scryfall.io/card-symbols/$normalizedSymbol.svg';
  }

  @override
  Widget build(BuildContext context) {
    if (manaCost.isEmpty) {
      return const SizedBox.shrink();
    }

    final symbols = parseManaCost(manaCost);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: symbols.map((symbol) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: CachedSvgPicture(
            url: getSymbolUrl(symbol),
            width: symbolSize,
            height: symbolSize,
            placeholder: SizedBox(
              width: symbolSize,
              height: symbolSize,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }).toList(),
    );
  }
}
