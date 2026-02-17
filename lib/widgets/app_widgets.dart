import 'package:flutter/material.dart';

Widget buildAppTextField({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction? textInputAction,
  List<String>? autofillHints,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    autofillHints: autofillHints,
    decoration: InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ), // border color when not focused
        borderRadius: BorderRadius.circular(10), // border radius
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 109, 199, 241),
          width: 2,
        ), // border color when focused
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 181, 60, 51)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 181, 60, 51)),
        borderRadius: BorderRadius.circular(8),
      ),
      suffixIcon: suffixIcon,
    ),
  );
}

Widget buildPrimaryButton({
  required String text,
  required VoidCallback onPressed,
  bool isLoading = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(
          255,
          109,
          199,
          241,
        ), // Button background color
        foregroundColor: Colors.white, // Text & icon color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // optional rounded corners
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.white, // Ensures text color
                fontSize: 16, // Optional font size
                fontWeight: FontWeight.bold, // Optional: bold text
              ),
            ),
    ),
  );
}
