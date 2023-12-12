import 'package:flutter/material.dart';

class CustomWidgets {
  Widget customTextField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.number,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String)? onChanged,
    readOnly = false,
    int maxlines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          readOnly: readOnly,
          maxLines: maxlines,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: labelText),
        ),
      ),
    );
  }

  Widget customElevatedButton({
    required String text,
    required Function() onPressed,
    double width = double.infinity,
    double height = 40,
  }) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
