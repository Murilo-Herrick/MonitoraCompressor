part of '_views_lib.dart';

class Pressure extends StatefulWidget {
  const Pressure({super.key});

  @override
  State<Pressure> createState() => _PressureState();
}

class _PressureState extends State<Pressure> {
  static const int maxPoints = 5;

  List<FlSpot> pressaoSpots = [];
  List<String> labels = [];

  double pressaoAtual = 0;
  String dataHora = '';
  Timer? timer;
  double tempo = 0;

  Future<void> atualizarDados() async {
    try {
      final data = await fetchDados();
      double press = double.tryParse(data['pressao'].toString()) ?? 0;
      String dataHoraRecebida = data['dataHora'] ?? '';

      if (!press.isFinite) throw Exception('Pressão inválida');

      setState(() {
        pressaoAtual = press;
        dataHora = dataHoraRecebida;
        tempo += 1;
        pressaoSpots.add(FlSpot(tempo, pressaoAtual));
        labels
            .add(dataHora.length >= 19 ? dataHora.substring(11, 19) : dataHora);

        if (pressaoSpots.length > maxPoints) {
          pressaoSpots.removeAt(0);
          labels.removeAt(0);
        }
      });
    } catch (e) {
      debugPrint('Erro ao atualizar dados de pressão: $e');
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

  Color get ponteiroColor {
    if (pressaoAtual >= 0 && pressaoAtual <= 14) {
      return Colors.orange;
    } else if (pressaoAtual >= 15 && pressaoAtual <= 25) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 400 ? 11.0 : 13.0;

    if (pressaoSpots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final double minX = pressaoSpots.first.x;
    final double maxX = pressaoSpots.last.x;

    final minPressao =
        pressaoSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxPressao =
        pressaoSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final avgPressao = pressaoSpots.map((e) => e.y).reduce((a, b) => a + b) /
        pressaoSpots.length;

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
                            Icon(Icons.speed,
                                color: const Color.fromARGB(255, 196, 68, 255),
                                size: 30),
                            const SizedBox(width: 8),
                            Text(
                              'Pressão Atual',
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
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 196, 68, 255)
                                .withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '${pressaoAtual.toStringAsFixed(1)} hPa',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 196, 68, 255),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 40,
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 14,
                                color: Colors.orange),
                            GaugeRange(
                                startValue: 14,
                                endValue: 27,
                                color: Colors.green),
                            GaugeRange(
                                startValue: 27,
                                endValue: 40,
                                color: Colors.red),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                                value: pressaoAtual,
                                needleColor: ponteiroColor),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                '${pressaoAtual.toStringAsFixed(1)} hPa',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              angle: 90,
                              positionFactor: 0.8,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(
                            label: 'Mínima',
                            value: minPressao,
                            color: Colors.orange,
                            unit: 'hPa'),
                        SizedBox(width: 8),
                        StatCard(
                            label: 'Média',
                            value: avgPressao,
                            color: Colors.green,
                            unit: 'hPa'),
                        SizedBox(width: 8),
                        StatCard(
                            label: 'Máxima',
                            value: maxPressao,
                            color: Colors.red,
                            unit: 'hPa'),
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
                              spots: pressaoSpots,
                              isCurved: true,
                              color: const Color.fromARGB(255, 196, 68, 255),
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color.fromARGB(255, 196, 68, 255)
                                    .withOpacity(0.2),
                              ),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                          minX: minX,
                          maxX: maxX,
                          minY: 0,
                          maxY: 40,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text(
                                'Pressão (hPa)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              axisNameSize: 20,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
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
                              tooltipBgColor:
                                  const Color.fromARGB(255, 196, 68, 255),
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
                                    'Hora: $time\nPressão: ${spot.y.toStringAsFixed(1)} hPa',
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
                    const SizedBox(height: 80),
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
