import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dartx/dartx.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:magicsearch_flutter_app/widgets/cached_image.dart';
import 'package:magicsearch_flutter_app/widgets/card_info_widget.dart';
import 'package:magicsearch_flutter_app/widgets/card_prices_widget.dart';
import 'package:magicsearch_flutter_app/widgets/card_toolbox_widget.dart';

/// A reusable widget that displays a Magic: The Gathering card with its image
/// and detailed information.
///
/// This widget can be used across different screens to display card details
/// consistently. Supports flipping double-sided cards.
class CardDisplayWidget extends HookWidget {
  final MagicCard card;
  final double maxImageWidth;
  final bool showImage;
  final bool showInfo;
  final String? heroTag;
  final VoidCallback? onArtistTap;

  const CardDisplayWidget({
    super.key,
    required this.card,
    this.maxImageWidth = 300,
    this.showImage = true,
    this.showInfo = true,
    this.heroTag,
    this.onArtistTap,
  });

  bool get _isDoubleSided =>
      card.cardFaces != null && card.cardFaces!.length >= 2;

  @override
  Widget build(BuildContext context) {
    final showFront = useState(true);
    final flipController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final flipAnim = useListenable(
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: flipController, curve: Curves.easeInOut),
      ),
    );

    final currentImageUrl = useCallback((bool front) {
      if (_isDoubleSided) {
        final faceList = card.cardFaces!;
        final face = front
            ? faceList.firstOrNull ?? faceList.first
            : faceList.lastOrNull ?? faceList.last;
        return face.imageUris?.large ?? face.imageUris?.normal;
      }
      return card.imageUris?.large ?? card.imageUris?.normal;
    }, [card, _isDoubleSided]);

    final toggleFlip = useCallback(() {
      if (!_isDoubleSided) return;
      if (flipController.isAnimating) return;
      flipController.forward(from: 0).then((_) {
        showFront.value = !showFront.value;
        flipController.reset();
      });
    }, [flipController, showFront, _isDoubleSided]);

    Widget buildImage() {
      Widget buildCardImage(bool front) {
        final imageUrl = currentImageUrl(front);
        final imageWidget = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxImageWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedImage(url: imageUrl ?? '', fit: BoxFit.contain),
          ),
        );
        if (heroTag != null && front) {
          return Hero(tag: heroTag!, child: imageWidget);
        }
        return imageWidget;
      }

      if (_isDoubleSided) {
        return AnimatedBuilder(
          animation: flipAnim,
          builder: (context, child) {
            final angle = flipAnim.value * 3.1416; // pi
            final showingFront = angle < 1.5708; // pi/2
            final displayFront = showFront.value == showingFront;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: displayFront
                  ? buildCardImage(true)
                  : buildCardImage(false),
            );
          },
        );
      } else {
        return buildCardImage(true);
      }
    }

    Widget buildImageSection() {
      return Column(
        children: [
          buildImage(),
          if (_isDoubleSided) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: toggleFlip,
              icon: const Icon(Icons.flip),
              label: Text(showFront.value ? 'Show Back' : 'Show Front'),
            ),
          ],
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showImage) ...[buildImageSection(), const SizedBox(height: 12)],
        if (showInfo) ...[
          CardInfoWidget(card: card, onArtistTap: onArtistTap),
          const SizedBox(height: 12),
          CardPricesWidget(card: card),
          const SizedBox(height: 12),
          CardToolboxWidget(card: card),
        ],
      ],
    );
  }
}
