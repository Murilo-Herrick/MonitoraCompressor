part of '_views_lib.dart';

class AboutDispositiveView extends StatefulWidget {
  const AboutDispositiveView({super.key});

  @override
  State<AboutDispositiveView> createState() => _AboutDispositiveViewState();
}

class _AboutDispositiveViewState extends State<AboutDispositiveView> {
  Map<String, String> _deviceData = {};

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> deviceData = {};

    try {
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'Marca': 'Android',
          'Modelo': info.model,
          'Versão Android': info.version.release,
          'SDK': '${info.version.sdkInt}',
          'ID do dispositivo': info.id,
          'Fabricante': info.manufacturer,
          'Dispositivo': info.device,
          'Produto': info.product,
        };
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'Marca': 'iOS',
          'Modelo': info.utsname.machine,
          'Sistema': info.systemName,
          'Versão': info.systemVersion,
          'Nome': info.name,
          'ID do dispositivo': info.identifierForVendor ?? '',
        };
      } else {
        deviceData = {
          'Plataforma': 'Não suportada',
        };
      }
    } catch (e) {
      deviceData = {
        'Erro': 'Não foi possível obter as informações do dispositivo',
      };
    }

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Content(
        title: "SENAI",
        body: _deviceData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _deviceData.length,
                itemBuilder: (context, index) {
                  final key = _deviceData.keys.elementAt(index);
                  final value = _deviceData[key];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(value ?? ''),
                      leading: const Icon(
                        Icons.phone_android,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
