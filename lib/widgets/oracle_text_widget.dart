import 'package:flutter/material.dart';
import 'package:magicsearch_flutter_app/widgets/mana_cost_widget.dart';
import 'cached_svg_picture.dart';
 

/// Widget that displays Magic: The Gathering oracle text with inline mana symbols.
///
/// Parses oracle text containing mana symbols like `{2}{B}` and displays them
/// as inline SVG icons from Scryfall's CDN.
class OracleTextWidget extends StatelessWidget {
  final String oracleText;
  final double symbolSize;
  final TextStyle? textStyle;

  const OracleTextWidget({
    super.key,
    required this.oracleText,
    this.symbolSize = 16.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (oracleText.isEmpty) {
      return const SizedBox.shrink();
    }

    final defaultStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium;

    // Split by newlines to create separate paragraphs for each ability
    final paragraphs = oracleText.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        if (paragraph.isEmpty) {
          return const SizedBox(height: 8);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildParagraph(paragraph, defaultStyle),
        );
      }).toList(),
    );
  }

  Widget _buildParagraph(String text, TextStyle? style) {
    final spans = _parseOracleText(text, style);
    
    return Text.rich(
      TextSpan(children: spans),
      style: style,
    );
  }

  /// Parses oracle text and returns a list of InlineSpans with text and mana symbols.
  /// Reminder text in parentheses is rendered in italics.
  List<InlineSpan> _parseOracleText(String text, TextStyle? style, {bool isItalic = false}) {
    final List<InlineSpan> spans = [];
    // Match mana symbols {X} or reminder text (text)
    final regex = RegExp(r'\{([^}]+)\}|\(([^)]+)\)');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null,
        ));
      }

      if (match.group(1) != null) {
        // Mana symbol
        final symbol = match.group(1)!;
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: CachedSvgPicture(
              url: ManaCostWidget.getSymbolUrl(symbol),
              width: symbolSize,
              height: symbolSize,
              placeholder: SizedBox(
                width: symbolSize,
                height: symbolSize,
              ),
            ),
          ),
        ));
      } else if (match.group(2) != null) {
        // Reminder text in parentheses - render contents in italics with mana symbols
        spans.add(const TextSpan(
          text: '(',
          style: TextStyle(fontStyle: FontStyle.italic),
        ));
        spans.addAll(_parseOracleText(match.group(2)!, style, isItalic: true));
        spans.add(const TextSpan(
          text: ')',
          style: TextStyle(fontStyle: FontStyle.italic),
        ));
      }

      lastEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null,
      ));
    }

    return spans;
  }
}
