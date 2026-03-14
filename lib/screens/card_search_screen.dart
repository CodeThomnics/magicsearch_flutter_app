import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:magicsearch_flutter_app/providers/card_search_provider.dart';
import 'package:magicsearch_flutter_app/widgets/card_display_widget.dart';
import 'package:magicsearch_flutter_app/widgets/mana_cost_widget.dart';

class CardSearchScreen extends HookConsumerWidget {
  const CardSearchScreen({super.key});

  void _showCardDetail(BuildContext context, MagicCard card) {
    context.push('/card/${card.id}');
  }

  void _openAdvancedSearch(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AdvancedSearchSheet(
        onSearch: (query) {
          if (query.trim().isNotEmpty) {
            ref.read(cardSearchQueryProvider.notifier).setQuery(query.trim());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final searchResult = ref.watch(cardSearchProvider);
    final query = ref.watch(cardSearchQueryProvider);

    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final searchDebounce = useRef<Timer?>(null);
    useListenable(controller);

    final search = useCallback(() {
      final query = controller.text.trim();
      if (query.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a card name'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      // Cancel previous search if still pending
      searchDebounce.value?.cancel();
      // Debounce search to avoid rapid requests
      searchDebounce.value = Timer(const Duration(milliseconds: 300), () {
        ref.read(cardSearchQueryProvider.notifier).setQuery(query);
        focusNode.unfocus();
      });
    }, [controller, ref, focusNode, searchDebounce]);

    final clear = useCallback(() {
      searchDebounce.value?.cancel();
      controller.clear();
      ref.read(cardSearchQueryProvider.notifier).clear();
      focusNode.requestFocus();
    }, [controller, ref, focusNode, searchDebounce]);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Cards')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              controller: controller,
              focusNode: focusNode,
              hintText: 'Search by card name…',
              leading: const Icon(Icons.search),
              trailing: [
                if (controller.text.isNotEmpty)
                  IconButton(icon: const Icon(Icons.clear), onPressed: clear),
              ],
              onSubmitted: (_) => search(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: search,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _openAdvancedSearch(context, ref),
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Advanced'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: query.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.style,
                          size: 64,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for a card by name',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : searchResult.when(
                    data: (result) {
                      if (result == null) return const SizedBox.shrink();
                      if (result.isExact) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: CardDisplayWidget(card: result.exactCard!),
                          ),
                        );
                      }
                      return _CardGrid(
                        cards: result.cards,
                        onCardTap: (card) => _showCardDetail(context, card),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            '$error'.replaceFirst('Exception: ', ''),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CardGrid extends StatelessWidget {
  final List<MagicCard> cards;
  final void Function(MagicCard) onCardTap;

  const _CardGrid({required this.cards, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            '${cards.length} results',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return GestureDetector(
                onTap: () => onCardTap(card),
                child: Hero(
                  tag: 'card-${card.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      card.imageUris?.normal
                          ?? card.cardFaces?[0].imageUris?.normal
                          ?? '',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (_, _, _) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AdvancedSearchSheet extends HookWidget {
  final void Function(String query) onSearch;

  const _AdvancedSearchSheet({required this.onSearch});

  static const List<(String, String, String, Color, Color)> _colorOptions = [
    ('w', 'White',    'W', Color(0xFFF5E6A3), Color(0xDD000000)),
    ('u', 'Blue',     'U', Color(0xFF0E68AB), Color(0xFFFFFFFF)),
    ('b', 'Black',    'B', Color(0xFF21160F), Color(0xFFFFFFFF)),
    ('r', 'Red',      'R', Color(0xFFD3202A), Color(0xFFFFFFFF)),
    ('g', 'Green',    'G', Color(0xFF00733E), Color(0xFFFFFFFF)),
    ('c', 'Colorless','C', Color(0xFF9C8D88), Color(0xFFFFFFFF)),
  ];

  static const List<(String, String, Color)> _rarityOptions = [
    ('common',   'Common',   Color(0xFF909090)),
    ('uncommon', 'Uncommon', Color(0xFF5A7F9A)),
    ('rare',     'Rare',     Color(0xFFC6A845)),
    ('mythic',   'Mythic',   Color(0xFFBF4427)),
  ];

  static const _formats = [
    'standard', 'pioneer', 'modern', 'legacy', 'vintage', 'commander', 'pauper',
  ];

  static const _cmcOps = ['=', '>=', '<=', '>', '<'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nameCtrl   = useTextEditingController();
    final typeCtrl   = useTextEditingController();
    final setCtrl    = useTextEditingController();
    final oracleCtrl = useTextEditingController();
    final cmcCtrl    = useTextEditingController();

    final selectedColors    = useState<Set<String>>({});
    final colorMatch        = useState('including'); // including, exactly, atmost
    final selectedRarities  = useState<Set<String>>({});
    final cmcOp             = useState('=');
    final selectedFormat    = useState<String?>(null);

    String buildQuery() {
      final parts = <String>[];

      final name = nameCtrl.text.trim();
      if (name.isNotEmpty) parts.add(name);

      final colors = selectedColors.value;
      if (colors.isNotEmpty) {
        final colorless = colors.contains('C') && colors.length == 1;
        final colorStr = colors.where((c) => c != 'C').join().toLowerCase();
        if (colorless) {
          parts.add('c:c');
        } else if (colorStr.isNotEmpty) {
          switch (colorMatch.value) {
            case 'exactly': parts.add('c=$colorStr');
            case 'atmost':  parts.add('c<=$colorStr');
            default:        parts.add('c>=$colorStr');
          }
        }
      }

      final type = typeCtrl.text.trim();
      if (type.isNotEmpty) {
        for (final t in type.split(RegExp(r'\s+'))) {
          if (t.isNotEmpty) parts.add('t:$t');
        }
      }

      final rarities = selectedRarities.value;
      if (rarities.length == 1) {
        parts.add('r:${rarities.first}');
      } else if (rarities.length > 1) {
        parts.add('(${rarities.map((r) => 'r:$r').join(' or ')})');
      }

      final cmc = cmcCtrl.text.trim();
      if (cmc.isNotEmpty && int.tryParse(cmc) != null) {
        parts.add('cmc${cmcOp.value}$cmc');
      }

      final setCode = setCtrl.text.trim();
      if (setCode.isNotEmpty) parts.add('s:$setCode');

      if (selectedFormat.value != null) parts.add('f:${selectedFormat.value}');

      final oracle = oracleCtrl.text.trim();
      if (oracle.isNotEmpty) parts.add('o:"$oracle"');

      return parts.join(' ');
    }

    Widget sectionLabel(String label) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Advanced Search',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Body
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Name ──────────────────────────────────────────────
                  sectionLabel('Card Name'),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Lightning Bolt',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Colors ────────────────────────────────────────────
                  sectionLabel('Colors'),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final (scryCode, label, code, bg, fg) in _colorOptions)
                        FilterChip(
                          label: ManaCostWidget(manaCost: '{${scryCode.toUpperCase()}}', symbolSize: 18),
                          tooltip: label,
                          selected: selectedColors.value.contains(code),
                          backgroundColor: bg.withValues(alpha: 0.15),
                          selectedColor: bg,
                          checkmarkColor: fg,
                          side: BorderSide(color: bg),
                          onSelected: (v) {
                            final next = Set<String>.from(selectedColors.value);
                            v ? next.add(code) : next.remove(code);
                            selectedColors.value = next;
                          },
                        ),
                    ],
                  ),
                  // Color match mode (only shown when colored pips selected)
                  if (selectedColors.value.isNotEmpty &&
                      !(selectedColors.value.length == 1 &&
                          selectedColors.value.contains('C'))) ...[
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'including', label: Text('Includes')),
                        ButtonSegment(value: 'exactly',   label: Text('Exactly')),
                        ButtonSegment(value: 'atmost',    label: Text('At Most')),
                      ],
                      selected: {colorMatch.value},
                      onSelectionChanged: (v) => colorMatch.value = v.first,
                      style: SegmentedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ── Type ──────────────────────────────────────────────
                  sectionLabel('Type'),
                  TextField(
                    controller: typeCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Creature Wizard',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Rarity ────────────────────────────────────────────
                  sectionLabel('Rarity'),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final (rarity, label, color) in _rarityOptions)
                        FilterChip(
                          label: Text(
                            label,
                            style: TextStyle(
                              color: selectedRarities.value.contains(rarity)
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: selectedRarities.value.contains(rarity),
                          backgroundColor: color.withAlpha(38),
                          selectedColor: color,
                          checkmarkColor: Colors.white,
                          side: BorderSide(color: color),
                          onSelected: (v) {
                            final next =
                                Set<String>.from(selectedRarities.value);
                            v ? next.add(rarity) : next.remove(rarity);
                            selectedRarities.value = next;
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── CMC ───────────────────────────────────────────────
                  sectionLabel('Mana Value (CMC)'),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: cmcOp.value,
                        items: [
                          for (final op in _cmcOps)
                            DropdownMenuItem(value: op, child: Text(op)),
                        ],
                        onChanged: (v) => cmcOp.value = v!,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: cmcCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '0',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Set ───────────────────────────────────────────────
                  sectionLabel('Set Code'),
                  TextField(
                    controller: setCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. dsk, blb, otj',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Format ────────────────────────────────────────────
                  sectionLabel('Format Legality'),
                  DropdownButtonFormField<String>(
                    initialValue: selectedFormat.value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                          value: null, child: Text('Any format')),
                      for (final f in _formats)
                        DropdownMenuItem<String>(
                          value: f,
                          child: Text(
                              f[0].toUpperCase() + f.substring(1)),
                        ),
                    ],
                    onChanged: (v) => selectedFormat.value = v,
                  ),
                  const SizedBox(height: 20),

                  // ── Oracle text ───────────────────────────────────────
                  sectionLabel('Oracle Text Contains'),
                  TextField(
                    controller: oracleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. flying, draw a card',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Search button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: FilledButton.icon(
                  onPressed: () {
                    final query = buildQuery();
                    if (query.trim().isEmpty) return;
                    Navigator.pop(context);
                    onSearch(query);
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
