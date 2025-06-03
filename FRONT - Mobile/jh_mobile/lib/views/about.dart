part of '_views_lib.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
    return false;
  }

  final List<Developer> developers = [
    Developer(
      nome: 'Murilo Camargo',
      cargo: 'Desenvolvedor Mobile',
      email: 'muriloherrick@gmail.com',
      telefone: 'Celular: (16) 99754-4500',
      fotoUrl: 'assets/images/img_murilo.jpg',
    ),
    Developer(
      nome: 'Nicolas Ribeiro',
      cargo: 'Desenvolvedor de embarcados e infraestrutura',
      email: 'oloconicao@gmail.com',
      telefone: 'Celular: (16) 99120-4354',
      fotoUrl: 'assets/images/img_nicolas.jpg',
    ),
    Developer(
      nome: 'Pedro Martins',
      cargo: 'Desenvolvedor backend',
      email: 'pedroenriquellopes2011@gmail.com',
      telefone: 'Celular: (16) 988986-0994',
    ),
    Developer(
      nome: 'Vinicius Ramos',
      cargo: 'Desenvolvedor de embarcados',
      email: 'viniciusaugusto6996@gmail.com',
      telefone: 'Celular: (16) 99251-5599',
    ),
    Developer(
      nome: 'Vinicius Gaban',
      cargo: 'Desenvolvedor Mobile',
      email: 'gabanvinicius724@gmail.com',
      telefone: 'Celular: (16) 99100-0062',
      fotoUrl: 'assets/images/img_gaban.jpg',
      githubUrl: 'https://github.com/Gaban03',
      linkedinUrl: 'https://www.linkedin.com/in/vinicius-gaban/',
    ),
  ];

  void _openDeveloperDetail(Developer dev) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeveloperProfilePage(developer: dev),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double maxContentWidth = MediaQuery.of(context).size.width > 700
        ? 700
        : MediaQuery.of(context).size.width * 0.95;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Content(
        title: "SENAI",
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre o Projeto',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Este projeto tem como objetivo o monitoramento de compressores em tempo real, '
                    'utilizando sensores e dispositivos de medição para garantir o bom funcionamento e a manutenção preventiva dos compressores. '
                    'Ele visa otimizar o desempenho e reduzir custos operacionais ao proporcionar uma análise precisa e contínua do funcionamento dos compressores.',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Icon(Icons.people_alt_rounded,
                          size: 30, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(
                        'Desenvolvedores',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ...developers.map(
                    (dev) => InkWell(
                      onTap: () => _openDeveloperDetail(dev),
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.black.withOpacity(0.1),
                      child: Card(
                        elevation: 6,
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor:
                                    const Color.fromARGB(255, 246, 92, 92),
                                child: ClipOval(
                                  child: dev.fotoUrl != null
                                      ? _buildProfileImage(dev.fotoUrl!)
                                      : Center(
                                          child: Text(
                                            dev.nome.substring(0, 1),
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 26,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 22),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dev.nome,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      dev.cargo,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.email,
                                            size: 18, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            dev.email,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.openSans(
                                              fontSize: 15,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 18, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            dev.telefone,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.openSans(
                                              fontSize: 15,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        url,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    }
  }
}
