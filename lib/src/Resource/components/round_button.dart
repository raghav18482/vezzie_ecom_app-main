//
import 'package:flutter/material.dart';
import '../color/colors.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    this.loading = false,
    required this.title,
    this.pinkButton = false,
    this.transprantButton = false,
    this.radius = 30,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final bool pinkButton;
  final bool transprantButton;
  final bool loading;
  final VoidCallback onPress;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: transprantButton
              ? Colors.transparent
              : (pinkButton)
                  ? AppColors.pink
                  : AppColors.buttonColor,
          borderRadius: BorderRadius.circular(radius),
          border: transprantButton ? Border.all(color: Colors.grey) : null,
        ),
        height: 40,
        width: 200,
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : Text(
                  title,
                  style: TextStyle(
                    color: transprantButton
                        ? AppColors.pink
                        : AppColors.whileColor,
                    fontFamily: "Inter",
                  ),
                ),
        ),
      ),
    );
  }
}
