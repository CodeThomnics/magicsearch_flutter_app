import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:magicsearch_flutter_app/models/card.dart';
import 'package:magicsearch_flutter_app/providers/dio_provider.dart';


final randomCardProvider = FutureProvider((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/cards/random');
  try {
    return MagicCard.fromJson(response.data);
  } catch (e, stack) {
    debugPrint('[RandomCard] JSON parse error: $e');
    debugPrintStack(label: '[RandomCard] Stack trace', stackTrace: stack);
    rethrow;
  }
});
