part of '_widgets_lib.dart';

class DialogAction {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    IconData? icon,
    Color? iconColor,
    String confirmText = "Sim",
    String cancelText = "Cancelar",
    Color confirmColor = Colors.redAccent,
    Color cancelColor = Colors.grey,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: icon != null
            ? Icon(
                icon,
                color: iconColor ?? Colors.redAccent,
                size: 40,
              )
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: cancelColor,
              textStyle: GoogleFonts.poppins(),
            ),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              confirmText,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
