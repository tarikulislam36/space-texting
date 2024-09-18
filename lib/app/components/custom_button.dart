import 'package:flutter/material.dart';
import 'package:space_texting/app/services/responsive_size.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Widget? leadingIcon;
  final TextStyle? textStyle;
  final Color? buttonColor;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.onPressed,
    this.leadingIcon,
    this.textStyle,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff9C3FE4), Color(0xffC65647)]),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0, // Remove the shadow to better see the gradient
            backgroundColor:
                Colors.transparent, // Use transparent to show the gradient
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) leadingIcon!,
              6.kwidthBox,
              if (buttonText.isNotEmpty && textStyle == null)
                Text(buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    )),
              if (buttonText.isNotEmpty && textStyle != null)
                Text(buttonText, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
