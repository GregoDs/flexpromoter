import 'package:flutter/widgets.dart';

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/icon/flexpaylogo.png
  AssetGenImage get flexpay =>
      const AssetGenImage('assets/icon/flexpaylogo.png');
}

  AssetGenImage get onboardingSlide1 =>
      const AssetGenImage('assets/images/onboardingSlide1.png');

   AssetGenImage get onboardingSlide2 =>
      const AssetGenImage('assets/images/onboardingSlide1.png');

  AssetGenImage get onboardingSlide3 =>
      const AssetGenImage('assets/images/onboardingSlide1.png');

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  /// Returns an `Image` widget for the asset
  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  /// Returns an `ImageProvider` for the asset
  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  /// Returns the asset path as a string
  String get path => _assetName;

  /// Returns the asset key name
  String get keyName => _assetName;
}
