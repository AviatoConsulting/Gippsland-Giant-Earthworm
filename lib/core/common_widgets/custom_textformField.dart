// ignore_for_file: file_names, library_private_types_in_public_api, constant_identifier_names, implicit_call_tearoffs

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

enum TextFieldType { alphabet, email, text, password, phoneNumber, number }

/// A customizable text form field with support for different types (e.g., password, email).
/// Provides validators, password toggle, and various layout options.
class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.textFieldType = TextFieldType.text,
    this.hintText,
    this.helperText,
    this.onChanged,
    this.maxLength,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.helperMaxLines,
    this.textAlign = TextAlign.left,
    this.inputFormatters,
    this.enabled = true,
    this.isReadOnly = false,
    this.textInputAction,
    this.textInputType,
    this.minLength = 1,
    this.minline = 1,
    this.onTap,
  });

  final TextEditingController? controller;
  final TextFieldType textFieldType;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? helperMaxLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int minLength;
  final int minline;
  final Function()? onTap;
  final bool isReadOnly;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true; // Controls visibility of password text

  // Toggles the visibility of password text
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Validators for different text field types
    final alphabetValidator = MultiValidator([
      RequiredValidator(errorText: "Please enter a value"),
      PatternValidator(r'^[A-Za-z_ .,]+$', errorText: "Invalid data format"),
    ]);

    final emailValidator = MultiValidator([
      RequiredValidator(errorText: "Please enter your email address"),
      EmailValidator(errorText: "Invalid email address format"),
    ]);

    final passwordValidator = MultiValidator([
      RequiredValidator(errorText: "Please enter your password"),
      MinLengthValidator(6,
          errorText: "Password must be more than 6 characters"),
    ]);

    final phoneNumberValidator = MultiValidator([
      RequiredValidator(errorText: "Please enter your phone number"),
      MinLengthValidator(7, errorText: "Invalid phone number format"),
      PatternValidator(r'^[0-9]+$', errorText: "Invalid phone number format"),
    ]);

    final textValidator = MultiValidator([
      RequiredValidator(errorText: "Please enter a value"),
      MinLengthValidator(widget.minLength, errorText: "Data is too short"),
    ]);

    final numberValidator = MultiValidator([
      RequiredValidator(errorText: "Please enter a value"),
      MinLengthValidator(1, errorText: "Data is too short"),
      PatternValidator(r'^[0-9]+$', errorText: "Invalid number format"),
    ]);

    // Selects keyboard type based on text field type
    TextInputType keyboardType(TextFieldType type) {
      switch (type) {
        case TextFieldType.alphabet:
        case TextFieldType.text:
          return TextInputType.text;
        case TextFieldType.email:
          return TextInputType.emailAddress;
        case TextFieldType.number:
          return TextInputType.number;
        case TextFieldType.password:
          return TextInputType.text;
        case TextFieldType.phoneNumber:
          return TextInputType.phone;
      }
    }

    // Selects validator based on text field type
    MultiValidator validator(TextFieldType type) {
      switch (type) {
        case TextFieldType.alphabet:
          return alphabetValidator;
        case TextFieldType.email:
          return emailValidator;
        case TextFieldType.number:
          return numberValidator;
        case TextFieldType.password:
          return passwordValidator;
        case TextFieldType.phoneNumber:
          return phoneNumberValidator;
        case TextFieldType.text:
          return textValidator;
      }
    }

    const double SPACE12 = 12.0;
    const double RADIUS = 8.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        onTap: widget.onTap,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        cursorColor: AppColor.primaryColor,
        selectionControls: EmptyTextSelectionControls(),
        textAlign: widget.textAlign ?? TextAlign.left,
        obscureText: widget.textFieldType == TextFieldType.password
            ? _obscureText
            : false,
        style: theme.textTheme.bodyLarge,
        inputFormatters: widget.inputFormatters ?? [],
        keyboardType:
            widget.textInputType ?? keyboardType(widget.textFieldType),
        validator: validator(widget.textFieldType),
        textInputAction: widget.textInputAction,
        minLines: widget.minline,
        onChanged: widget.onChanged,
        readOnly: widget.isReadOnly,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: theme.textTheme.titleSmall?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          labelText: widget.labelText,
          labelStyle: theme.textTheme.titleMedium,
          suffixIcon: widget.textFieldType == TextFieldType.password
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppColor.primaryColor,
                  ),
                  onPressed: _toggleObscureText,
                )
              : widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          helperMaxLines: widget.helperMaxLines,
          helperText: widget.helperText,
          helperStyle: theme.textTheme.titleSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          fillColor: Get.isDarkMode ? Colors.white10 : const Color(0xFFF2F4F5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: SPACE12, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RADIUS),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RADIUS),
            borderSide:
                BorderSide(color: AppColor.primaryColor.withOpacity(0.5)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RADIUS),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(RADIUS),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
