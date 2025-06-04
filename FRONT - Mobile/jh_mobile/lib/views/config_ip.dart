part of '_views_lib.dart';

class ConfigIP extends StatefulWidget {
  const ConfigIP({super.key});

  @override
  State<ConfigIP> createState() => _ConfigIPState();
}

class _ConfigIPState extends State<ConfigIP> {
  final _formKey = GlobalKey<FormState>();
  final ipController = TextEditingController();
  final portController = TextEditingController();
  final portAPIController = TextEditingController();

  String? ssid;
  String? localIP;
  String? connectionType;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _obterInfoRede();
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    portAPIController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipController.text = prefs.getString('ip') ?? '10.110.18.6';
      portController.text = prefs.getString('port') ?? '9095';
      portAPIController.text = prefs.getString('portAPI') ?? '5010';
    });
  }

  Future<void> _obterInfoRede() async {
    final connectivity = await Connectivity().checkConnectivity();
    final info = NetworkInfo();

    final ip = await info.getWifiIP();
    final wifiName = await info.getWifiName();

    setState(() {
      localIP = ip ?? "Não disponível";
      ssid = wifiName ?? "Desconhecida";
      switch (connectivity) {
        case ConnectivityResult.wifi:
          connectionType = "Wi-Fi";
          break;
        case ConnectivityResult.mobile:
          connectionType = "Dados móveis";
          break;
        case ConnectivityResult.ethernet:
          connectionType = "Ethernet";
          break;
        case ConnectivityResult.bluetooth:
          connectionType = "Bluetooth";
          break;
        case ConnectivityResult.vpn:
          connectionType = "VPN";
          break;
        case ConnectivityResult.other:
          connectionType = "Outro";
          break;
        case ConnectivityResult.none:
        default:
          connectionType = "Sem conexão";
          break;
      }
    });
  }

  Future<void> _salvarDados() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', ipController.text.trim());
    await prefs.setString('portAPI', portAPIController.text.trim());
    await prefs.setString('port', portController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações salvas com sucesso!')),
    );
  }

  String? _validarIP(String? value) {
    if (value == null || value.isEmpty) return 'Informe o IP';
    final ipRegex =
        RegExp(r'^(?:(?:25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)(\.|$)){4}$');
    if (!ipRegex.hasMatch(value)) return 'IP inválido';
    return null;
  }

  String? _validarPorta(String? value) {
    if (value == null || value.isEmpty) return 'Informe a porta';
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) return 'Porta inválida';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Content(
          title: "SENAI",
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: ipController,
                    label: "Endereço IP",
                    hint: "Ex: 192.168.0.1",
                    prefixIcon: Icons.language,
                    validator: _validarIP,
                    inputTextStyle: const TextStyle(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: portController,
                    label: "Porta",
                    hint: "Ex: 8080",
                    prefixIcon: Icons.dns,
                    validator: _validarPorta,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: portAPIController,
                    label: "Porta da API",
                    hint: "Ex: 5000",
                    prefixIcon: Icons.api,
                    validator: _validarPorta,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      onPressed: _salvarDados,
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildNetworkInfoCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.15),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rede Atual",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.wifi, "Conexão", connectionType),
            _buildInfoRow(Icons.router, "SSID", ssid ?? "Desconhecida"),
            _buildInfoRow(
                Icons.device_unknown, "IP local", localIP ?? "Não disponível"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value ?? "-"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
