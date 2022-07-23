import 'package:flutter/material.dart';

import 'DotNavigationBarItem.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.curve,
    required this.duration,
    required this.selectedItemColor,
    required this.theme,
    required this.unselectedItemColor,
    required this.onTap,
    required this.itemPadding,
    required this.dotIndicatorColor,
    required this.enablePaddingAnimation,
  }) : super(key: key);

  final List<DotNavigationBarItem> items;
  final int currentIndex;
  final Curve curve;
  final Duration duration;
  final Color? selectedItemColor;
  final ThemeData theme;
  final Color? unselectedItemColor;
  final Function(int p1) onTap;
  final EdgeInsets itemPadding;
  final Color? dotIndicatorColor;
  final bool enablePaddingAnimation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final item in items)
          TweenAnimationBuilder<double>(
            tween: Tween(
              end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
            ),
            curve: curve,
            duration: duration,
            builder: (context, t, _) {
              final _selectedColor =
                  item.selectedColor ?? selectedItemColor ?? theme.primaryColor;

              final _unselectedColor = item.unselectedColor ??
                  unselectedItemColor ??
                  theme.iconTheme.color;

              return Material(
                color: Color.lerp(Colors.transparent, Colors.transparent, t),
                child: InkWell(
                  enableFeedback: false,
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => onTap.call(items.indexOf(item)),
                  focusColor: _selectedColor.withOpacity(0.1),
                  highlightColor: _selectedColor.withOpacity(0.1),
                  splashColor: _selectedColor.withOpacity(0.1),
                  hoverColor: _selectedColor.withOpacity(0.1),
                  child: Stack(children: <Widget>[
                    Padding(
                      padding: itemPadding -
                          (enablePaddingAnimation
                              ? EdgeInsets.only(right: itemPadding.right * t)
                              : EdgeInsets.zero),
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                  _unselectedColor, _selectedColor, t),
                              size: 24,
                            ),
                            child: item.icon,
                          ),
                        ],
                      ),
                    ),
                    ClipRect(
                      child: SizedBox(
                        height: 40,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          widthFactor: t,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: itemPadding.right / 0.63,
                                right: itemPadding.right),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color.lerp(
                                    _selectedColor.withOpacity(0.0),
                                    _selectedColor,
                                    t),
                                fontWeight: FontWeight.w600,
                              ),
                              child: CircleAvatar(
                                  radius: 2.5,
                                  backgroundColor: dotIndicatorColor != null
                                      ? dotIndicatorColor
                                      : _selectedColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
      ],
    );
  }
}
