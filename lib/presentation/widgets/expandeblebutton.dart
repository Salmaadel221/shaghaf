import 'package:flutter/material.dart';

class ExpandableBookButton extends StatefulWidget {
  final VoidCallback onNavigate;
  final Color backgroundColor;
  final Color iconColor;

  const ExpandableBookButton({
    super.key,
    required this.onNavigate,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  State<ExpandableBookButton> createState() => _ExpandableBookButtonState();
}

class _ExpandableBookButtonState extends State<ExpandableBookButton>
    with TickerProviderStateMixin {


  late AnimationController glowController;
  late Animation<double> glowAnimation;

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(begin: 0.0, end: 14.0).animate(
      CurvedAnimation(
        parent: glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    glowController.dispose();
    super.dispose();
  }

  void onTapAction() {
    // The user expects a single tap to navigate to the room screen.
    // The original logic was for a two-step expansion/navigation.
    // We will change it to navigate directly.
    widget.onNavigate();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final buttonHeight = width * 0.13; // 🔥 Responsive height
    final iconSize = width * 0.07; // 🔥 Responsive icon
    final fontSize = width * 0.045; // 🔥 Responsive text
    final horizontalPadding = width * 0.03;

    return GestureDetector(
      onTap: onTapAction,
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          return Container(
              height: buttonHeight,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(buttonHeight / 2),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.7),
                    blurRadius: glowAnimation.value,
                    spreadRadius: glowAnimation.value / 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.videogame_asset,
                    color: widget.iconColor,
                    size: iconSize,
                  ),
                  SizedBox(width: width * 0.03),
                  Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: widget.iconColor,
                    ),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}
