import 'package:flutter/material.dart';

/// Widget which can be used as a normal button, but is intended for use as a expandable button in a [ButtonNavigationBar]
class ButtonNavigationExpandable extends StatelessWidget {
  const ButtonNavigationExpandable(
      {this.label,
      this.icon,
      this.color,
      this.height,
      this.width,
      this.borderRadius,
      required this.onPressed,
      Key? key})
      : super(key: key);

  /// The [label] defines the text inside of the button.
  final String? label;

  /// The icon inside of the button.
  final Icon? icon;

  /// The color of the button.
  final Color? color;

  /// Height of the button.
  final double? height;

  /// Width of the button.
  final double? width;

  /// [BorderRadius] can be used to make rounded Buttons.
  final BorderRadius? borderRadius;

  /// Sets triggered action when button is pressed.
  final VoidCallback onPressed;

  Widget _childBuilder(Icon? icon, String? label) {
    if (icon != null && label != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Text(label)
        ],
      );
    } else if (icon != null) {
      return icon;
    } else if (label != null) {
      return Text(label);
    } else {
      return const SizedBox.shrink();
    }
  }

  ButtonStyle? _buttonStyle(Color? color, BorderRadius? borderRadius) {
    if (color != null && borderRadius != null) {
      return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: borderRadius)),
        foregroundColor: MaterialStateProperty.all<Color>(color),
      );
    } else if (borderRadius != null) {
      return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: borderRadius)),
      );
    } else if (color != null) {
      return ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(color),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle(color, borderRadius),
        child: _childBuilder(icon, label),
      ),
    );
  }
}
