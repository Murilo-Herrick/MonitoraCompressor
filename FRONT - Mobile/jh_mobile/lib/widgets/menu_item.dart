part of '_widgets_lib.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = Colors.black87,
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(icon, size: 20, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
