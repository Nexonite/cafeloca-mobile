import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class CafelocaTextField extends StatelessWidget {
  const CafelocaTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixPressed,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: AppColors.textPrimary,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            suffixIcon: suffixIcon == null
                ? null
                : IconButton(
                    onPressed: onSuffixPressed,
                    icon: Icon(suffixIcon, size: 20),
                    color: AppColors.textSecondary,
                  ),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(color: AppColors.textPrimary),
            errorBorder: _border(color: AppColors.error),
            focusedErrorBorder: _border(color: AppColors.error),
            errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border({Color color = AppColors.border}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
