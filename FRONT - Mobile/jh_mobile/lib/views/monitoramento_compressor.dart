part of '_views_lib.dart';

class MonitoramentoCompressorPage extends StatefulWidget {
  const MonitoramentoCompressorPage({super.key});

  @override
  State<MonitoramentoCompressorPage> createState() =>
      _MonitoramentoCompressorPageState();
}

class _MonitoramentoCompressorPageState
    extends State<MonitoramentoCompressorPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Temperature(),
    const Humidity(),
    const Pressure(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
    return false;
  }

  Widget _buildIcon(IconData iconData, bool selected) {
    return Container(
      padding: selected ? const EdgeInsets.all(6) : EdgeInsets.zero,
      decoration: selected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            )
          : null,
      child: Icon(
        iconData,
        size: selected ? 28 : 24,
        color: Colors.white,
        shadows: const [
          Shadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Text _buildTitle(String text, bool selected) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        fontSize: selected ? 14 : 12,
        color: Colors.white,
        shadows: const [
          Shadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 0, 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SalomonBottomBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              items: [
                SalomonBottomBarItem(
                  icon: _buildIcon(
                      Icons.thermostat_outlined, _selectedIndex == 0),
                  title: _buildTitle("Temperatura", _selectedIndex == 0),
                  selectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  icon: _buildIcon(
                      Icons.water_drop_outlined, _selectedIndex == 1),
                  title: _buildTitle("Umidade", _selectedIndex == 1),
                  selectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  icon: _buildIcon(Icons.speed_outlined, _selectedIndex == 2),
                  title: _buildTitle("Pressão", _selectedIndex == 2),
                  selectedColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
