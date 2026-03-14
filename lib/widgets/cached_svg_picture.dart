import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CachedSvgPicture extends HookWidget {
  final String url;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final BoxFit fit;

  const CachedSvgPicture({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.placeholder,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final cacheManager = useMemoized(() => CacheManager(Config('svgCache')));

    final fileFuture = useMemoized(() async {
      try {
        final cached = await cacheManager.getFileFromCache(url);
        if (cached != null && cached.file.existsSync()) return cached.file;
        final fetched = await cacheManager.getSingleFile(url);
        return fetched;
      } catch (_) {
        return null;
      }
    }, [url]);

    return FutureBuilder<File?>(
      future: fileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              SizedBox(
                width: width,
                height: height,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
        }

        final file = snapshot.data;
        if (file != null) {
          return SvgPicture.file(file, width: width, height: height, fit: fit);
        }

        return placeholder ?? SizedBox(width: width, height: height);
      },
    );
  }
}
