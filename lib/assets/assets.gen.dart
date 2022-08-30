/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow-left-3.svg
  SvgGenImage get arrowLeft3 =>
      const SvgGenImage('assets/icons/arrow-left-3.svg');

  /// File path: assets/icons/arrow-swap-horizontal.svg
  SvgGenImage get arrowSwapHorizontal =>
      const SvgGenImage('assets/icons/arrow-swap-horizontal.svg');

  /// File path: assets/icons/calendar.svg
  SvgGenImage get calendar => const SvgGenImage('assets/icons/calendar.svg');

  /// File path: assets/icons/camera.svg
  SvgGenImage get camera => const SvgGenImage('assets/icons/camera.svg');

  /// File path: assets/icons/category.svg
  SvgGenImage get category => const SvgGenImage('assets/icons/category.svg');

  /// File path: assets/icons/clock.svg
  SvgGenImage get clock => const SvgGenImage('assets/icons/clock.svg');

  /// File path: assets/icons/direct-normal.svg
  SvgGenImage get directNormal =>
      const SvgGenImage('assets/icons/direct-normal.svg');

  /// File path: assets/icons/direct-notification.svg
  SvgGenImage get directNotification =>
      const SvgGenImage('assets/icons/direct-notification.svg');

  /// File path: assets/icons/direct-send.svg
  SvgGenImage get directSend =>
      const SvgGenImage('assets/icons/direct-send.svg');

  /// File path: assets/icons/direct.svg
  SvgGenImage get direct => const SvgGenImage('assets/icons/direct.svg');

  /// File path: assets/icons/document-text.svg
  SvgGenImage get documentText =>
      const SvgGenImage('assets/icons/document-text.svg');

  /// File path: assets/icons/edit-2.svg
  SvgGenImage get edit2 => const SvgGenImage('assets/icons/edit-2.svg');

  /// File path: assets/icons/edit.svg
  SvgGenImage get edit => const SvgGenImage('assets/icons/edit.svg');

  /// File path: assets/icons/eraser-1.svg
  SvgGenImage get eraser1 => const SvgGenImage('assets/icons/eraser-1.svg');

  /// File path: assets/icons/grid-1.svg
  SvgGenImage get grid1 => const SvgGenImage('assets/icons/grid-1.svg');

  /// File path: assets/icons/home-1.svg
  SvgGenImage get home1 => const SvgGenImage('assets/icons/home-1.svg');

  /// File path: assets/icons/information.svg
  SvgGenImage get information =>
      const SvgGenImage('assets/icons/information.svg');

  /// File path: assets/icons/logout.svg
  SvgGenImage get logout => const SvgGenImage('assets/icons/logout.svg');

  /// File path: assets/icons/menu-1.svg
  SvgGenImage get menu1 => const SvgGenImage('assets/icons/menu-1.svg');

  /// File path: assets/icons/message-question.svg
  SvgGenImage get messageQuestion =>
      const SvgGenImage('assets/icons/message-question.svg');

  /// File path: assets/icons/note-1.svg
  SvgGenImage get note1 => const SvgGenImage('assets/icons/note-1.svg');

  /// File path: assets/icons/note-2.svg
  SvgGenImage get note2 => const SvgGenImage('assets/icons/note-2.svg');

  /// File path: assets/icons/people.svg
  SvgGenImage get people => const SvgGenImage('assets/icons/people.svg');

  /// File path: assets/icons/personalcard.svg
  SvgGenImage get personalcard =>
      const SvgGenImage('assets/icons/personalcard.svg');

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg');

  /// File path: assets/icons/security-safe.svg
  SvgGenImage get securitySafe =>
      const SvgGenImage('assets/icons/security-safe.svg');

  /// File path: assets/icons/setting-2.svg
  SvgGenImage get setting2 => const SvgGenImage('assets/icons/setting-2.svg');

  /// File path: assets/icons/sms-notification.svg
  SvgGenImage get smsNotification =>
      const SvgGenImage('assets/icons/sms-notification.svg');

  /// File path: assets/icons/sms.svg
  SvgGenImage get sms => const SvgGenImage('assets/icons/sms.svg');
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const AssetGenImage logoAmber = AssetGenImage('assets/logo_amber.png');
  static const AssetGenImage logoBlue = AssetGenImage('assets/logo_blue.png');
  static const AssetGenImage logoOrange =
      AssetGenImage('assets/logo_orange.png');
  static const AssetGenImage logoOrg = AssetGenImage('assets/logo_org.png');
  static const AssetGenImage userAvatar =
      AssetGenImage('assets/user_avatar.png');
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double size = 24,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: size,
      height: size,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;
}
