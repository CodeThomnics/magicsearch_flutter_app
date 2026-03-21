import 'package:flutter/material.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:dartx/dartx.dart';
import 'package:magicsearch_flutter_app/widgets/mana_cost_widget.dart';
import 'package:magicsearch_flutter_app/widgets/oracle_text_widget.dart';

/// Widget that displays card information including name, mana cost, and type line.
class CardInfoWidget extends StatelessWidget {
  final MagicCard card;
  final VoidCallback? onArtistTap;

  const CardInfoWidget({super.key, required this.card, this.onArtistTap});

  bool get _isDoubleSided =>
      card.cardFaces != null && card.cardFaces!.length >= 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline;

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isDoubleSided)
            ..._buildDoubleSidedContent(theme, borderColor)
          else
            ..._buildSingleSidedContent(theme, borderColor),

          // Legalities grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildLegalitiesGrid(theme),
          ),

          // Illustrator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Icon( 
                  Icons.brush,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Row(
                  children: [
                    Text(
                      'Illustrated by ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (onArtistTap != null)
                      GestureDetector(
                        onTap: onArtistTap,
                        child: Text(
                          card.artist,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    else
                      Text(
                        card.artist,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSingleSidedContent(ThemeData theme, Color borderColor) {
    return [
      _buildNameHeader(
        card.name,
        card.manaCost ?? '',
        theme,
        borderColor,
        isTop: true,
      ),
      _buildTypeLine(card.typeLine, theme, borderColor),
      _buildSetAndRarity(theme, borderColor),
      _buildOracleText(card.oracleText ?? '', theme),
      if (card.flavorText != null && card.flavorText!.isNotEmpty)
        _buildFlavorText(card.flavorText!, theme),
      if (card.power != null && card.toughness != null)
        _buildPowerToughness(card.power!, card.toughness!, theme, borderColor),
    ];
  }

  List<Widget> _buildDoubleSidedContent(ThemeData theme, Color borderColor) {
    final faces = card.cardFaces!;
    final frontFace = faces.firstOrNull ?? faces[0];
    final backFace = faces.elementAtOrNull(1) ?? faces[1];
    return [
      // Front face
      _buildNameHeader(
        frontFace.name ?? card.name,
        frontFace.manaCost ?? '',
        theme,
        borderColor,
        isTop: true,
      ),
      _buildTypeLine(frontFace.typeLine ?? card.typeLine, theme, borderColor),
      _buildSetAndRarity(theme, borderColor),
      _buildOracleText(frontFace.oracleText ?? '', theme),
      if (frontFace.power != null && frontFace.toughness != null)
        _buildPowerToughness(
          frontFace.power!,
          frontFace.toughness!,
          theme,
          borderColor,
        ),

      // Divider between faces
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border(
            top: BorderSide(color: borderColor, width: 2),
            bottom: BorderSide(color: borderColor, width: 2),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flip,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Back Face',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),

      // Back face
      _buildNameHeader(
        backFace.name ?? '',
        backFace.manaCost ?? '',
        theme,
        borderColor,
        isTop: false,
      ),
      _buildTypeLine(backFace.typeLine ?? '', theme, borderColor),
      _buildSetAndRarity(theme, borderColor),
      _buildOracleText(backFace.oracleText ?? '', theme),
      if (backFace.power != null && backFace.toughness != null)
        _buildPowerToughness(
          backFace.power!,
          backFace.toughness!,
          theme,
          borderColor,
        ),
    ];
  }

  Widget _buildNameHeader(
    String name,
    String manaCost,
    ThemeData theme,
    Color borderColor, {
    required bool isTop,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: isTop
            ? const BorderRadius.vertical(top: Radius.circular(10))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          ManaCostWidget(manaCost: manaCost),
        ],
      ),
    );
  }

  Widget _buildTypeLine(String typeLine, ThemeData theme, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Text(
        typeLine,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOracleText(String oracleText, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: OracleTextWidget(oracleText: oracleText),
    );
  }

  Widget _buildFlavorText(String flavorText, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        flavorText,
        style: theme.textTheme.bodySmall?.copyWith(
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildPowerToughness(
    String power,
    String toughness,
    ThemeData theme,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$power/$toughness',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLegalitiesGrid(ThemeData theme) {
    final legalities = {
      'Standard': card.legalities.standard,
      'Pioneer': card.legalities.pioneer,
      'Modern': card.legalities.modern,
      'Legacy': card.legalities.legacy,
      'Vintage': card.legalities.vintage,
      'Commander': card.legalities.commander,
      'Oathbreaker': card.legalities.oathbreaker,
      'Alchemy': card.legalities.alchemy,
      'Historic': card.legalities.historic,
      'Brawl': card.legalities.brawl,
      'Timeless': card.legalities.timeless,
      'Pauper': card.legalities.pauper,
      'Penny': card.legalities.penny,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 8,
          children: legalities.entries.map((entry) {
            return _buildLegalityRow(
              entry.key,
              entry.value,
              card.gameChanger,
              theme,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLegalityRow(
    String format,
    String status,
    bool gameChanger,
    ThemeData theme,
  ) {
    String statusLabel;
    Color statusColor;

    switch (status) {
      case 'legal':
        if (gameChanger && format == 'Commander') {
          statusLabel = 'Legal/GC';
          statusColor = Colors.green.shade500;
        } else {
          statusLabel = 'Legal';
          statusColor = Colors.green.shade800;
        }
        break;
      case 'banned':
        statusLabel = 'Banned';
        statusColor = Colors.red.shade700;
        break;
      case 'not_legal':
      default:
        statusLabel = 'Not Legal';
        statusColor = Colors.grey.shade500;
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            format,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(25),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            statusLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetAndRarity(ThemeData theme, Color borderColor) {
    final setCode = card.cardSet;
    final setName = card.setName;
    final rarity = card.rarity;

    Color rarityColor;
    switch (rarity) {
      case 'common':
        rarityColor = Colors.grey.shade600;
        break;
      case 'uncommon':
        rarityColor = Colors.green.shade700;
        break;
      case 'rare':
        rarityColor = Colors.deepPurple.shade700;
        break;
      case 'mythic':
        rarityColor = Colors.orange.shade700;
        break;
      default:
        rarityColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$setName (${setCode.toUpperCase()})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: rarityColor.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: rarityColor),
            ),
            child: Text(
              rarity.capitalize(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: rarityColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
