part of '_views_lib.dart';

class Humidity extends StatefulWidget {
  const Humidity({super.key});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  static const int maxPoints = 5;

  List<FlSpot> umidadeSpots = [];
  List<String> labels = [];

  double umidadeAtual = 0;
  String dataHora = '';
  Timer? timer;
  double tempo = 0;

  Future<void> atualizarDados() async {
    try {
      final data = await fetchDados();
      double hum = double.tryParse(data['umidade'].toString()) ?? 0;
      String dataHoraRecebida = data['dataHora'] ?? '';

      if (!hum.isFinite) throw Exception('Umidade inválida');

      setState(() {
        umidadeAtual = hum;
        dataHora = dataHoraRecebida;
        tempo += 1;
        umidadeSpots.add(FlSpot(tempo, umidadeAtual));
        labels
            .add(dataHora.length >= 19 ? dataHora.substring(11, 19) : dataHora);

        if (umidadeSpots.length > maxPoints) {
          umidadeSpots.removeAt(0);
          labels.removeAt(0);
        }
      });
    } catch (e) {
      debugPrint('Erro ao atualizar dados de umidade: $e');
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

    if (umidadeSpots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final double minX = umidadeSpots.first.x;
    final double maxX = umidadeSpots.last.x;

    final minHum = umidadeSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxHum = umidadeSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final avgHum = umidadeSpots.map((e) => e.y).reduce((a, b) => a + b) /
        umidadeSpots.length;

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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.water_drop,
                              color: Colors.blueAccent, size: 30),
                          const SizedBox(width: 8),
                          Text(
                            'Umidade Atual',
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
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '${umidadeAtual.toStringAsFixed(2)} %',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                          label: 'Mínima',
                          value: minHum,
                          color: Colors.blue.shade700,
                          unit: '%'),
                      SizedBox(width: 8),
                      StatCard(
                          label: 'Média',
                          value: avgHum,
                          color: Colors.blue.shade400,
                          unit: '%'),
                      SizedBox(width: 8),
                      StatCard(
                          label: 'Máxima',
                          value: maxHum,
                          color: Colors.blue.shade900,
                          unit: '%'),
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
                            spots: umidadeSpots,
                            isCurved: true,
                            color: Colors.blueAccent,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blueAccent.withOpacity(0.2),
                            ),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                        minX: minX,
                        maxX: maxX,
                        minY: 0,
                        maxY: 100,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'Umidade (%)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            axisNameSize: 25,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 24,
                              interval: 10,
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
                          horizontalInterval: 10,
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
                            tooltipBgColor: Colors.blueAccent,
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
                                  'Hora: $time\nUmidade: ${spot.y.toStringAsFixed(2)} %',
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
            );
          },
        ),
      ),
    );
  }
}
