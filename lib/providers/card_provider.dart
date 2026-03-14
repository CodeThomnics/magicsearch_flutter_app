import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:magicsearch_flutter_app/providers/dio_provider.dart';

final cardByIdProvider = FutureProvider.family<MagicCard, String>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/cards/$id');
  try {
    return MagicCard.fromJson(response.data);
  } catch (e, stack) {
    // Preserve existing debugging style
    // ignore: avoid_print
    print('[CardById] JSON parse error: $e');
    // ignore: avoid_print
    print(stack);
    rethrow;
  }
});
