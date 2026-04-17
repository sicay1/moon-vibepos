import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Future<bool?> showDeleteConfirmDialog(BuildContext context,
    {String? title, String? message}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title ?? 'Delete?'),
      content: Text(message ?? 'This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
