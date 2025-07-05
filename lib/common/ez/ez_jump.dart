

import 'package:flutter/material.dart';

final class EzJumpOnTap extends StatefulWidget {
  final double? dy;
  final Widget child;

  const EzJumpOnTap({super.key,  this.dy = 0.05, required this.child});

  @override
  State<StatefulWidget> createState() {
    return _JumpState();
  }
}

class _JumpState extends State<EzJumpOnTap> {
  Offset _offset = Offset(0,  0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _offset = Offset(0, -widget.dy!)),
      onTapUp: (_) => setState(() => _offset = Offset(0,  0)),
      child: Transform.translate(
        offset: _offset,
        child: widget.child,
      ),
    );
  }
}