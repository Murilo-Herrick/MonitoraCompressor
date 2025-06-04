part of 'htpp_lib.dart';

Future<String> getIp() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('ip') ?? '';
}

Future<String> getPort() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('port') ?? '1880';
}

Future<String> getPortAPI() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('portAPI') ?? '5010';
}

Future<Map<String, dynamic>> fetchDados() async {
  try {
    final ip = await getIp();
    final port = await getPort();

    final response = await http.get(Uri.parse('http://$ip:$port/dados'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Erro ao carregar dados: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro na requisição: $e');
  }
}

Future<Map<String, dynamic>> recebeEstado() async {
  final ip = await getIp();
  final port = await getPort();

  try {
    final response = await http.get(Uri.parse('http://$ip:$port/bobina'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'bobina': data['bobina'] as bool,
        'data': data['data'] as String,
      };
    } else {
      throw Exception('Erro ao carregar estado: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro na requisição: $e');
  }
}

Future<void> enviarEstado(bool estado) async {
  final ip = await getIp();
  final port = await getPort();

  try {
    final url = Uri.parse('http://$ip:$port/estadoBobina');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'bobina': estado}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar estado: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro na requisição POST: $e');
  }
}

Future<List<dynamic>> fetchEmergencias() async {
  final ip = await getIp();
  final portAPI = await getPortAPI();

  final response = await http.get(Uri.parse('http://$ip:$portAPI/historicoEmergencias'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['dados'];
  } else {
    throw Exception('Erro ao carregar emergências: ${response.statusCode}');
  }
}