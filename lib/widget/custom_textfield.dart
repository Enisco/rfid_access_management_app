// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

TextStyle labelTextStyles = TextStyle(
  fontSize: 15,
  color: Colors.grey[500],
);

TextStyle hintTextStyles = const TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(153, 153, 153, 1),
);

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    Key? key,
    this.fillColor,
    this.labelText,
    this.hintText,
    this.textEditingController,
    this.hasSuffixIcon = false,
    this.onSuffixIconPressed,
    this.suffixIcon,
    this.focusNode,
    this.initialValue,
    this.hasPrefixIcon = false,
    this.onPrefixIconPressed,
    this.keyboardType,
    this.prefixText,
    this.readOnly,
    this.prefixStyle,
    this.floatingLabelStyle,
    this.suffixIconSize,
    this.letterSpacing,
    this.obscureText,
    this.onChanged,
    this.maxLines,
    this.onTap,
    this.inputStringStyle,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization,
    this.contentpadding,
    this.scrollPadding,
    this.onSubmitted,
    this.autofocus,
    this.enabled = true,
    this.suffixText,
    this.textMaxLength,
  }) : super(key: key);

  final EdgeInsets? scrollPadding;
  final Color? fillColor;
  final String? labelText;
  final String? prefixText;
  final String? initialValue;
  final double? suffixIconSize;
  final double? letterSpacing;
  final String? suffixText;
  final String? hintText;
  final bool? enabled;
  final bool? readOnly;
  final bool? autofocus;
  final int? maxLines;
  final int? textMaxLength;
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final bool? obscureText;
  final IconData? suffixIcon;
  final FocusNode? focusNode;
  final TextStyle? inputStringStyle;
  final TextStyle? prefixStyle;
  final TextStyle? floatingLabelStyle;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final TextInputAction textInputAction;
  final TextCapitalization? textCapitalization;
  final void Function()? onSuffixIconPressed;
  final void Function()? onPrefixIconPressed;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final EdgeInsetsGeometry? contentpadding;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        letterSpacing: widget.letterSpacing ?? 1.0,
      ),
      controller: widget.textEditingController,
      maxLength: widget.textMaxLength,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        fillColor: widget.fillColor ?? Colors.grey[100],
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber,
            width: 1.0,
          ),
        ),
        labelStyle: labelTextStyles,
        hintStyle: hintTextStyles,
        counterText: '',
      ),
    );
  }
}
