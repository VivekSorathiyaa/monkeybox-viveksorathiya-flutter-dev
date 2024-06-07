import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final bool? isProfile;
  final bool? isVideoFeed;
  final Color? color;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  const NetworkImageWidget({
    this.isProfile = false,
    Key? key,
    this.height,
    this.width,
    this.color,
    this.isVideoFeed,
    this.fit,
    this.imageUrl,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius!,
      child: CachedNetworkImage(
        key: ValueKey(imageUrl),
        fit: fit ?? BoxFit.cover,
        height: height,
        // maxWidthDiskCache: 350,
        // memCacheWidth: 350,
        cacheKey: imageUrl,
        width: width,
        filterQuality: FilterQuality.low,
        color: color,
        useOldImageOnUrlChange: true,
        fadeOutDuration: const Duration(milliseconds: 0),
        fadeOutCurve: Curves.easeInOut,
        fadeInDuration: const Duration(microseconds: 0),
        fadeInCurve: Curves.easeIn,
        imageUrl: imageUrl!,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Center(
            child: Lottie.asset(
              'assets/json/loader.json',
              height: 100,
              width: 100,
            ),
          );
        },
        errorWidget: (context, url, error) {
          log("image Widget load error :> $error  $imageUrl");
          return Center(
            child: Lottie.asset(
              'assets/json/loader.json',
              height: 100,
              width: 100,
            ),
          );
        },
      ),
    );
  }
}
