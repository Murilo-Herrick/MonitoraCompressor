part of '_widgets_lib.dart';

final User? user = AuthService().currentUser;

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF4D4D),
                      Color(0xFFFF0000),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        "Usuário não logado",
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final user = snapshot.data!;
                    final String? photoURL = user.photoURL;
                    final String displayEmail = user.email != null
                        ? user.email!.replaceAllMapped(
                            RegExp(r'(.{3}).+@'), (m) => '${m[1]}***@')
                        : "Sem e-mail";
                    final lastLogin = user.metadata.lastSignInTime;

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.white70, Colors.white10],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(2.5),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: photoURL != null
                                ? NetworkImage(photoURL)
                                : const AssetImage(
                                        "assets/images/default_user.png")
                                    as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (user.displayName != null)
                          Text(
                            user.displayName!,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email_outlined,
                                color: Color.fromARGB(255, 255, 252, 252),
                                size: 16),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                displayEmail,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (lastLogin != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.access_time,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 16),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('dd/MM/yyyy – HH:mm')
                                    .format(lastLogin.toLocal()),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 255, 250, 250),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              MenuItem(
                icon: FontAwesomeIcons.house,
                title: "Início",
                onTap: () => _navigateTo(context, const HomeView()),
              ),
              MenuItem(
                icon: FontAwesomeIcons.gear,
                title: "Configurações",
                onTap: () => _navigateTo(context, ConfigPage()),
              ),
              MenuItem(
                icon: FontAwesomeIcons.circleInfo,
                title: "Sobre",
                onTap: () => _navigateTo(context, About()),
              ),
              const Divider(height: 30),
              MenuItem(
                icon: FontAwesomeIcons.arrowRightFromBracket,
                title: "Sair",
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () async {
                  final confirmed = await DialogAction.show(
                    context: context,
                    title: "Confirmar saída",
                    content: "Tem certeza que deseja sair da sua conta?",
                    icon: Icons.logout,
                    iconColor: Colors.red,
                  );
                  if (confirmed) {
                    await AuthService().signout(context: context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
