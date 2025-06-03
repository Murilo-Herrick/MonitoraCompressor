part of '_views_lib.dart';

class CompressorControl extends StatefulWidget {
  const CompressorControl({super.key});

  @override
  State<CompressorControl> createState() => _CompressorControlState();
}

class _CompressorControlState extends State<CompressorControl> {
  bool isTapped = false;
  bool ligado = false;
  String? dataEstado;

  @override
  void initState() {
    super.initState();
    carregarEstado();
  }

  Future<void> carregarEstado() async {
    try {
      final estadoBobina = await recebeEstado();
      bool estado = estadoBobina['bobina'];
      String data = estadoBobina['data'];
      setState(() {
        ligado = estado;
        dataEstado = data;
      });
    } catch (e) {
      print('Erro ao carregar estado: $e');
    }
  }

  Future<bool> _onWillPop() async {
    // Navegar para a HomeView substituindo a tela atual
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
    // Impedir a navegação para a tela anterior
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Content(
              title: "SENAI",
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: Column(
                  children: [

                    SizedBox(
                      height: MediaQuery.of(context).size.height * .08,
                    ),

                    Text(
                      "Controle do Compressor",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 0),
                      child: Text(
                        dataEstado != null
                            ? 'Última atividade: $dataEstado'
                            : 'Carregando data...',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ligado ? Colors.red : Colors.grey.shade400,
                        boxShadow: ligado
                            ? [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        ligado ? Icons.power : Icons.power_off,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      ligado ? 'Compressor ligado' : 'Compressor desligado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ligado ? Colors.redAccent : Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Center(
                        child: Container(
                      width: MediaQuery.of(context).size.width * .5,
                      height: 60,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(2)),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ligado ? Colors.red : Colors.green,
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.9),
                        ),
                        onPressed: () async {
                          // adds a delay to prevent spamming
                          if (!isTapped) {
                            try {
                              isTapped = true;
                              final novoEstado = !ligado;
                              await enviarEstado(novoEstado);

                              final resultado = await recebeEstado();
                              bool bobinaEstado = resultado['bobina'];
                              String novaData = resultado['data'];
                              setState(() {
                                ligado = bobinaEstado;
                                dataEstado = novaData;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 5000));
                              isTapped = false;
                            } catch (e) {
                              print('Erro ao enviar estado $e');
                            }
                          }
                        },
                        child: Text(ligado ? 'Desligar' : 'Ligar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                      ),
                    )),
                  ],
                ),
              ))),
    );
  }
}
