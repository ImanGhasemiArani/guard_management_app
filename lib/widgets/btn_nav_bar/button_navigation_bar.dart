library button_navigation_bar;

import 'package:flutter/material.dart';

import 'builder.dart';

/// The  [ButtonNavigationBar] is the menu bar, in which [ButtonNavigationItem] get inserted.
///
/// Mainly used instead of [FloatingActionButton] (FAB) in a [Scaffold], but can be used in other scenarios as well.
/// When using this as a FAB, you might want to center it using "floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat",

class ButtonNavigationBar extends StatefulWidget {
  /// In [children] one can insert multiple [ButtonNavigationItem], which will be the elements of the menu bar.
  final List<ButtonNavigationItem> children;

  /// [padding] allows to set a padding around the menu bar. Not recommended when using Widget as FAB.
  final EdgeInsets padding;

  /// [spaceBetweenItems] allows customisation of gap between buttons.
  final double spaceBetweenItems;

  /// [borderRadius] is used to define ounding the four edges. A few examples:
  ///   - To round all four edges:
  ///       borderRadius: BorderRadius.all(Radius.circular(10))
  ///   - Set edges individually:
  ///       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.elliptical(3, 9)
  ///   - No edges:
  ///       borderRadius: BorderRadius.zero
  final BorderRadius borderRadius;

  const ButtonNavigationBar(
      {required this.children,
      this.padding = EdgeInsets.zero,
      this.spaceBetweenItems = 1.5,
      this.borderRadius = const BorderRadius.all(Radius.circular(16)),
      Key? key})
      : super(key: key);

  @override
  State<ButtonNavigationBar> createState() => _ButtonNavigationBarState();
}

class _ButtonNavigationBarState extends State<ButtonNavigationBar> {
  /// Adds the [rowChildBuilder] in one row to be passed to the row widget in [build]
  List<Widget> rowChildren(List<ButtonNavigationItem> children) {
    List<Widget> rowChildren = List.empty(growable: true);
    for (int i = 0; i < children.length; i++) {
      rowChildren.add(NavBarBuilder().rowChildBuilder(
          children[i], i, children.length, widget.borderRadius));
      if (i != children.length - 1) {
        rowChildren.add(Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.spaceBetweenItems)));
      }
    }
    return rowChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: rowChildren(widget.children),
      ),
    );
  }
}

/// A ButtonNavigationItem represents one button in the menu bar. Should be inserted in [ButtonNavigationBar.children].
class ButtonNavigationItem {
  /// The [label] is the text displayed on the button. If empty, no text is displayed on the button.
  final String? label;

  /// [icon] displays a passed Icon of the label text.
  final Icon? icon;

  /// [color] sets the color of the button. Buttons in the same menu can have different colors.
  final Color? color;

  /// [height] and [width] set the dimensions of the button. If left emtpy, height is 48 and with 72.
  final double height, width;

  /// [onPressed] sets the action of the button when pressed.
  final VoidCallback? onPressed;

  /// [children] are the expanding widgets in a [ButtonNavigationItem.expandable]
  final List<Widget>? children;

  /// [collapseButton] allows to customize the button which collapses the expanded buttons again. onPressed of a widget is always overwritten when using it here. Only for [ButtonNavigationItem.expandable].
  final ButtonNavigationItem? collapseButton;

  /// [expandableSpacing] can be used to define the spacing between the expandable buttons. Only for [ButtonNavigationItem.expandable].
  final double expandableSpacing;

  /// [verticalOffset] can be used to define the spacing between the [ButtonNavigationItem] and the first expandable Item. Only for [ButtonNavigationItem.expandable].
  final double verticalOffset;

  ButtonNavigationItem({
    this.label,
    this.icon,
    this.color,
    this.height = 48,
    this.width = 72,
    required this.onPressed,
  })  : children = null,
        collapseButton = null,
        expandableSpacing = 0,
        verticalOffset = 0;

  ButtonNavigationItem.expandable(
      {this.label,
      this.icon,
      this.color,
      this.height = 48,
      this.width = 72,
      required this.children,
      this.collapseButton,
      this.expandableSpacing = 50.0,
      this.verticalOffset = 50.0})
      : onPressed = null;
}
