part of "_widgets_lib.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationsPressed;

  @override
  final Size preferredSize;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNotificationsPressed,
    this.preferredSize = const Size.fromHeight(70),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF4D4D),
              Color(0xFFFF0000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.bars,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip: 'Menu',
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.bell,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: onNotificationsPressed ?? () {},
                      tooltip: 'Notificações',
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Center(
                          child: Text(
                            '!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
