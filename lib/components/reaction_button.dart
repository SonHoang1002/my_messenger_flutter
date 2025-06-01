import 'package:flutter/material.dart';

class ReactionButton extends StatelessWidget {
  final String emojiGif;
  final void Function() onSelect;
  final Size size;
  final EdgeInsets margin;

  const ReactionButton({
    super.key,
    required this.emojiGif,
    required this.onSelect,
    this.size = const Size(24, 24),
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  Widget _buildButton() {
    return InkWell(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        margin: margin,
        child: Image.asset(
          emojiGif,
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}


