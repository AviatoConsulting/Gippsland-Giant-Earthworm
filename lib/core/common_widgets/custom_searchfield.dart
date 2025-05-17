import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

/// A customizable search text field with options for prefix/suffix icons, read-only state,
/// custom hint text, and input change handling.
class CustomSearchTextField extends StatelessWidget {
  final String hintText; // Placeholder text for the search field
  final Widget? widget; // Optional prefix widget (defaults to a search icon)
  final bool isReadOnly; // If true, the text field is read-only
  final Function()? ontap; // Callback triggered on tap
  final Function(String)? onChange; // Callback triggered on text change
  final TextEditingController? controller; // Controller to manage input text
  final Widget? suffixIcon; // Optional suffix icon widget

  const CustomSearchTextField({
    super.key,
    this.hintText = "Search...",
    this.widget,
    this.ontap,
    this.controller,
    this.onChange,
    this.suffixIcon,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: ontap, // Triggers provided tap callback, if any
      onChanged: onChange, // Triggers provided change callback, if any
      controller: controller, // Manages the text input
      readOnly: isReadOnly, // Sets the field as read-only if true
      cursorColor: AppColor.primaryColor, // Custom cursor color
      selectionControls:
          EmptyTextSelectionControls(), // Custom selection controls
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Get.isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon, // Optional suffix icon
        filled: true,
        fillColor: Get.isDarkMode
            ? Colors.white10
            : Colors.grey.shade100, // Background color
        prefixIcon: widget ??
            const Icon(
              Icons.search,
              color: AppColor.primaryColor,
              size: 25,
            ), // Default search icon if no custom widget is provided
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          borderSide: const BorderSide(
            color: Colors.transparent, // Invisible border
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.transparent, // Border when enabled but unfocused
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColor.primaryColor, // Primary color border when focused
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 16.0), // Padding within the field
      ),
    );
  }
}
