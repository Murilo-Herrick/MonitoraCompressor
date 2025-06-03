part of '_views_lib.dart';

class EmergencyHistory extends StatefulWidget {
  const EmergencyHistory({super.key});

  @override
  State<EmergencyHistory> createState() => _EmergencyHistoryState();
}

class _EmergencyHistoryState extends State<EmergencyHistory> {
  List<dynamic> _emergencias = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    carregarEmergencias();
  }

  Future<void> carregarEmergencias() async {
    try {
      final emergencia = await fetchEmergencias();
      setState(() {
        _emergencias = emergencia;
        _carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar estado: $e');
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Content(
          title: "SENAI",
          body: _carregando
              ? Center(child: CircularProgressIndicator())
              : _emergencias.isEmpty
                  ? Center(
                      child: Text(
                        "Nenhuma emergência registrada!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      itemCount: _emergencias.length,
                      itemBuilder: (context, index) {
                        final e = _emergencias[index];
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text('Horário: ${e['horario']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Temperatura: ${e['temperatura']} °C'),
                                Text('Umidade: ${e['umidade']} %'),
                                Text('Pressão: ${e['pressao']} PSI'),
                                Text('Estado: ${e['estado']}'),
                                Text('Notificação: ${e['notificacao']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
