part of '_views_lib.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  static const int maxPoints = 5;

  List<FlSpot> temperaturaSpots = [];
  List<String> labels = [];

  double temperaturaAtual = 0;
  String dataHora = '';
  Timer? timer;
  double tempo = 0;

  Future<void> atualizarDados() async {
    try {
      final data = await fetchDados();
      double temp = double.tryParse(data['temperatura'].toString()) ?? 0;
      String dataHoraRecebida = data['dataHora'] ?? '';

      if (!temp.isFinite) throw Exception('Temperatura inválida');

      setState(() {
        temperaturaAtual = temp;
        dataHora = dataHoraRecebida;
        tempo += 1;
        temperaturaSpots.add(FlSpot(tempo, temperaturaAtual));
        labels
            .add(dataHora.length >= 19 ? dataHora.substring(11, 19) : dataHora);

        if (temperaturaSpots.length > maxPoints) {
          temperaturaSpots.removeAt(0);
          labels.removeAt(0);
        }
      });
    } catch (e) {
      debugPrint('Erro ao atualizar dados: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    atualizarDados();
    timer = Timer.periodic(const Duration(seconds: 5), (_) => atualizarDados());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 400 ? 11.0 : 13.0;

    if (temperaturaSpots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final double minX = temperaturaSpots.first.x;
    final double maxX = temperaturaSpots.last.x;

    final minTemp =
        temperaturaSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxTemp =
        temperaturaSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final avgTemp = temperaturaSpots.map((e) => e.y).reduce((a, b) => a + b) /
        temperaturaSpots.length;

    return Scaffold(
      body: Content(
        title: "SENAI",
        body: LayoutBuilder(
          builder: (context, constraints) {
            int labelInterval = 1;
            int maxLabels = (constraints.maxWidth / 60).floor();
            if (labels.length > maxLabels && maxLabels > 0) {
              labelInterval = (labels.length / maxLabels).ceil();
            }

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.thermostat,
                                color: Colors.redAccent, size: 30),
                            const SizedBox(width: 8),
                            Text(
                              'Temp. Atual',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          dataHora,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '${temperaturaAtual.toStringAsFixed(2)} °C',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(
                          label: 'Mínima',
                          value: minTemp,
                          color: Colors.blue,
                          unit: '°C',
                        ),
                        SizedBox(width: 8),
                        StatCard(
                          label: 'Média',
                          value: avgTemp,
                          color: Colors.orange,
                          unit: '°C',
                        ),
                        SizedBox(width: 8),
                        StatCard(
                          label: 'Máxima',
                          value: maxTemp,
                          color: Colors.red,
                          unit: '°C',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: temperaturaSpots,
                              isCurved: true,
                              color: Colors.redAccent,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.redAccent.withOpacity(0.2),
                              ),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          minX: minX,
                          maxX: maxX,
                          minY: 0,
                          maxY: 45,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text(
                                'Temperatura (°C)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              axisNameSize: 25,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                interval: 5,
                                getTitlesWidget: (value, meta) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    value.toStringAsFixed(0),
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Text(
                                  'Horário',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = (value - minX).round();
                                  if (index < 0 ||
                                      index >= labels.length ||
                                      index % labelInterval != 0) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      labels[index],
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 5,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              left: BorderSide(
                                  color: Colors.grey.shade600, width: 1),
                              bottom: BorderSide(
                                  color: Colors.grey.shade600, width: 1),
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.redAccent,
                              tooltipRoundedRadius: 12,
                              tooltipPadding: const EdgeInsets.all(8),
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final index = (spot.x - minX).round();
                                  final time =
                                      (index >= 0 && index < labels.length)
                                          ? labels[index]
                                          : '';
                                  return LineTooltipItem(
                                    'Hora: $time\nTemp: ${spot.y.toStringAsFixed(2)} °C',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
