part of '_widgets_lib.dart';

class ConfigListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ConfigListTile({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      splashColor: Colors.red.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 28, color: isEnabled ? Colors.red[700] : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: isEnabled ? Colors.black87 : Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 8),
            ],
            if (isEnabled)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              letterSpacing: 1.5,
            ),
      ),
    );
  }
}
