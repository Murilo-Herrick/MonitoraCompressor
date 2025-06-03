part of '_views_lib.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Content(
        title: "SENAI",
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SectionTitle("Rede"),
            ConfigListTile(
              title: "Configurar IP",
              icon: Icons.language,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfigIP()),
                );
              },
            ),
            SizedBox(height: 15),
            const SectionTitle("Sistema"),
            ConfigListTile(
              title: "Sobre o dispositivo",
              icon: Icons.info_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AboutDispositiveView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
