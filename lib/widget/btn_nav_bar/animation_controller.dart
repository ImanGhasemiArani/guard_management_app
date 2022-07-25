import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'builder.dart';
import 'button_navigation_bar.dart';

/// This Widget is generated from a [ButtonNavigationItem.expandable].
/// When clicked, it expands to reveal child widgets (for example a [ButtonNavigationExpandable]).
/// This widget should not be initialized directly from user code.
@immutable
class ExpandableRowChildButton extends StatefulWidget {
  /// [initialOpen] defines if the menu is expanded when initially loading the widget.
  final bool? initialOpen;

  /// [distance] the offset of the first expandable widget from the expandable Button
  final double distance;

  /// [children] are the widgets which will be shown when expanding
  final List<Widget> children;

  /// [position] is the position of the button in the navbar, 0 being the leftmost
  final int position;

  /// [navBarLength] is the number of buttons in the navbar.
  final int navBarLength;

  /// [borderRadius] is setting the edges of the navbar.
  final BorderRadius borderRadius;

  /// The [ButtonNavigationItem.expandable] which contains styling information.
  final ButtonNavigationItem item;

  const ExpandableRowChildButton({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
    required this.position,
    required this.navBarLength,
    required this.borderRadius,
    required this.item,
  }) : super(key: key);

  @override
  State<ExpandableRowChildButton> createState() =>
      _ExpandableRowChildButtonState();
}

class _ExpandableRowChildButtonState extends State<ExpandableRowChildButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(widget.item, widget.position, widget.navBarLength,
              widget.borderRadius),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(widget.item, widget.position, widget.navBarLength,
              widget.borderRadius),
        ],
      ),
    );
  }

  /// Builds the button which gets displayed when the expandable button gets clicked. Clicking this button will close the expandable again.
  Widget _buildTapToCloseFab(ButtonNavigationItem item, int position,
      int navBarLength, BorderRadius borderRadius) {
    ButtonNavigationItem? collapseButton = item.collapseButton;
    if (collapseButton == null) {
      collapseButton = ButtonNavigationItem(
          onPressed: _toggle,
          icon: const Icon(Icons.close)); // Defining the default collapse button
    } else {
      collapseButton = ButtonNavigationItem(
          onPressed: _toggle,
          icon: collapseButton.icon,
          color: collapseButton.color,
          width: collapseButton.width,
          height: collapseButton.height,
          label: collapseButton.label); // Overriding the onPressed parameter
    }
    return NavBarBuilder().buildRowChildButton(
        collapseButton, position, navBarLength, borderRadius);
  }

  /// Builds the Buttons that are displayed when the [ButtonNavigationItem.expandable] gets clicked.
  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = widget.item.expandableSpacing;
    for (var i = 0; i < count; i++) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: 90,
          maxDistance: widget.distance + i * step,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  /// Builds the expandable button.
  ///  Note that this same button doesn't close the expandable again. For this purpose, the [_buildTapToCloseFab] button is used.
  Widget _buildTapToOpenFab(ButtonNavigationItem item, int position,
      int navBarLength, BorderRadius borderRadius) {
    ButtonNavigationItem expandableItem = ButtonNavigationItem(
        onPressed: _toggle,
        icon: item.icon,
        label: item.label,
        color: item.color,
        height: item.height,
        width: item.width);
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: NavBarBuilder().buildRowChildButton(
              expandableItem, position, navBarLength, borderRadius),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
