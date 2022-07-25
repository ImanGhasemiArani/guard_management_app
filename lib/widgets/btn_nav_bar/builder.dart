import 'package:flutter/material.dart';

import 'animation_controller.dart';
import 'button_navigation_bar.dart';
import 'button_navigation_expandable.dart';

/// Class containing multiple builder functions, so they can be used by multiple widgets.
class NavBarBuilder {
  /// Checks if [item] is a expandable button and returns a [SizedBox].
  /// SizedBox contains a [ElevatedButton] when [item] doesn't have any children.
  /// SizedBox contains a [ExpandableRowChildButton] when [item] has children.
  SizedBox rowChildBuilder(ButtonNavigationItem item, int navBarLength,
      int position, BorderRadius borderRadius) {
    if (item.children != null) {
      /// When the item has children, it is a expandable button ([ButtonNavigationItem.expandable]).
      return buildExpandableRowChildButton(
          item, position, navBarLength, borderRadius);
    } else {
      return buildRowChildButton(item, position, navBarLength, borderRadius);
    }
  }

  /// Builds a [SizedBox] containing an [ElevatedButton] from a [ButtonNavigationItem]
  SizedBox buildRowChildButton(ButtonNavigationItem item, int navBarLength,
      int position, BorderRadius borderRadius) {
    return SizedBox(
      height: item.height,
      width: item.width,
      child: Material(
        color: item.color,
        borderRadius: borderBuilder(position, navBarLength, borderRadius),
        child: InkWell(
          enableFeedback: false,
          splashColor: Colors.red.withOpacity(0.1),
          borderRadius: borderBuilder(position, navBarLength, borderRadius),
          onTap: item.onPressed,
          child: childBuilder(item.icon, item.label),
        ),
      ),
    );
  }

  /// Builds a SizedBox containing the children of [ButtonNavigationItem]. The [ButtonNavigationItem] gets converted to a [ExpandableRowChildButton]
  SizedBox buildExpandableRowChildButton(ButtonNavigationItem item,
      int position, int navBarLength, BorderRadius borderRadius) {
    return SizedBox(
      child: ExpandableRowChildButton(
        distance: item.verticalOffset,
        borderRadius: borderRadius,
        navBarLength: navBarLength,
        position: position,
        item: item,
        children: item.children!,
      ),
    );
  }

  /// Creates an ElevatedButton and uses the [childBuilder] to generate a child.
  Widget buildExpandingButton(ButtonNavigationExpandable item) {
    return ElevatedButton(
        onPressed: item.onPressed, child: childBuilder(item.icon, item.label));
  }

  /// Gives the outer left- and right buttons the edges, which have been set using [ButtonNavigationBar.borderRadius]
  BorderRadius borderBuilder(
      int position, int childrenLength, BorderRadius borderRadius) {
    if (childrenLength == 1) {
      return BorderRadius.only(
          bottomLeft: borderRadius.bottomLeft,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomRight: borderRadius.bottomRight);
    } else if (position == 0) {
      return BorderRadius.only(
          bottomLeft: borderRadius.bottomLeft, topLeft: borderRadius.topLeft);
    } else if (position == childrenLength - 1) {
      return BorderRadius.only(
          bottomRight: borderRadius.bottomRight,
          topRight: borderRadius.topRight);
    } else {
      return BorderRadius.zero;
    }
  }

  /// Builds the content inside of the button, depending on if [icon] and [label] have been supplied.
  Widget childBuilder(Icon? icon, String? label) {
    if (icon != null && label != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, Text(label)],
      );
    } else if (icon != null) {
      return icon;
    } else if (label != null) {
      return Text(label);
    } else {
      return const SizedBox.shrink();
    }
  }
}
