part of '_widgets_lib.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final String? Function(String?)? validator;
  final VoidCallback? onToggleVisibility;
  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final double borderRadius;
  final double elevation;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.validator,
    this.onToggleVisibility,
    this.backgroundColor = const Color(0xFFF9F9F9),
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = const Color(0xFFEF5350), // vermelho elegante
    this.errorBorderColor = Colors.redAccent,
    this.borderRadius = 16.0,
    this.elevation = 2.0,
    this.labelStyle,
    this.hintStyle,
    this.inputTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isPassword ? obscureText : false,
          style: inputTextStyle ??
              const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            labelText: label,
            labelStyle:
                labelStyle ?? const TextStyle(fontSize: 14, color: Colors.grey),
            hintText: hint,
            hintStyle:
                hintStyle ?? const TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: Icon(prefixIcon, color: Colors.grey[700]),
            filled: true,
            fillColor: backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: errorBorderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: errorBorderColor, width: 2),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[700],
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
