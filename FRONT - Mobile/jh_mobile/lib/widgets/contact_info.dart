part of '_widgets_lib.dart';

class ContactInfo extends StatelessWidget {
  final Developer developer;
  const ContactInfo({super.key, required this.developer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContactRow(
          icon: Icons.email,
          text: developer.email,
        ),
        const SizedBox(height: 10),
        ContactRow(
          icon: Icons.phone,
          text: developer.telefone,
        ),
      ],
    );
  }
}
