import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Function(String?)? onSaved;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.fromARGB(255, 11, 72, 122);
    final textColor = Color.fromARGB(255, 11, 72, 122);

    return TextFormField(
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textColor, fontSize: 14.sp),
        hintStyle:
            TextStyle(color: textColor.withOpacity(0.6), fontSize: 14.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: textColor, fontSize: 14.sp),
      onSaved: onSaved,
    );
  }
}
