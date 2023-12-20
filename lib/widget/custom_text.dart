import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final TextOverflow? overflow;

  const CustomText(
      {super.key,
      required this.text,
      this.fontSize,
      this.color,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          fontSize: fontSize ?? 16, color: color ?? Colors.black),
      overflow: overflow,
    );
  }
}
