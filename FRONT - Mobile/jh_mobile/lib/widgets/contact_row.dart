part of '_widgets_lib.dart';

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.openSans(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
