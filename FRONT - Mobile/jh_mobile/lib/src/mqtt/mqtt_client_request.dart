part of 'mqtt_client_libs.dart';

typedef MqttCallback = void Function(String topic, String payload);

class MqttService {
  late MqttServerClient client;
  final MqttCallback onMessage;

  MqttService({required this.onMessage});

  Future<void> connect() async {
    client = MqttServerClient.withPort(
      'b29f84b0972441899ce848b7b2a4dbda.s1.eu.hivemq.cloud',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8883, // Porta SSL
    );

    client.logging(on: false);
    client.secure = true;
    client.setProtocolV311();

    client.keepAlivePeriod = 20;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs('Compressor', 'Compressor123')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      client.subscribe('Compressor', MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> events) {
        final recMess = events[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        onMessage(events[0].topic, payload);
      });
    } catch (e) {
      client.disconnect();
      rethrow;
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void onConnected() => print('MQTT Conectado');
  void onDisconnected() => print('MQTT Desconectado');
  void onSubscribed(String topic) => print('Inscrito no tópico: $topic');
}
