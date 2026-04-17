import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PlaceholderAvatar extends StatelessWidget {
  final String? imagePath;
  final double radius;
  final String initials;
  final Color backgroundColor;

  const PlaceholderAvatar({
    super.key,
    this.imagePath,
    this.radius = 28,
    this.initials = '?',
    this.backgroundColor = AppColors.lightBlue,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(imagePath!)),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        initials.isNotEmpty ? initials[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: radius * 0.65,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
