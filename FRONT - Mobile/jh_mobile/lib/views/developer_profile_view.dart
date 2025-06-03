part of '_views_lib.dart';

class DeveloperProfilePage extends StatelessWidget {
  final Developer developer;

  const DeveloperProfilePage({
    super.key,
    required this.developer,
  });

  @override
  Widget build(BuildContext context) {
    final redColor = Colors.red.shade700;

    return Scaffold(
      body: Content(
        title: 'SENAI',
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: redColor, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: redColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: developer.fotoUrl != null
                      ? DecorationImage(
                          image: developer.fotoUrl!.startsWith('http')
                              ? NetworkImage(developer.fotoUrl!)
                              : AssetImage(developer.fotoUrl!) as ImageProvider,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: developer.fotoUrl == null
                    ? Text(
                        developer.nome.substring(0, 1),
                        style: GoogleFonts.robotoSlab(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: redColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                developer.nome,
                style: GoogleFonts.robotoSlab(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                developer.cargo,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 28),
              _infoCard(icon: Icons.email, label: developer.email),
              const SizedBox(height: 10),
              _infoCard(icon: Icons.phone, label: developer.telefone),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(
                    assetPath: 'assets/images/github.png',
                    url: developer.githubUrl,
                    tooltip: 'GitHub',
                  ),
                  const SizedBox(width: 24),
                  _socialButton(
                    assetPath: 'assets/images/linkedin.png',
                    url: developer.linkedinUrl,
                    tooltip: 'LinkedIn',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required String assetPath,
    required String? url,
    required String tooltip,
  }) {
    final bool enabled = url != null && url.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: enabled
          ? () {
              if (url.isNotEmpty) {
                launchUrlString(url);
              }
            }
          : null,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: 60,
          height: 60,
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
