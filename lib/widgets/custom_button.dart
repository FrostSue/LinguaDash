import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double? width;
  final double height;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryPurple,
    this.width,
    this.height = 65,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.85,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0, 
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
        onPressed: onPressed,
        
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Monogram',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            maxLines: 1, 
          ),
        ),
      ),
    );
  }
}