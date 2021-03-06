import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  const TitleText(
    this.text, {
    Key key,
    this.fontSize = 16,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.visible,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.muli(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
