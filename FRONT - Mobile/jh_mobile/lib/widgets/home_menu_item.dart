part of '_widgets_lib.dart';

class HomeMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? warning;
  final IconData icon;
  final VoidCallback? onPressed;

  const HomeMenuItem({
    Key? key,
    required this.title,
    required this.subtitle,
    this.warning,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (warning != null)
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  warning!,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
