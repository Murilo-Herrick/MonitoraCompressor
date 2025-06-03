part of "_widgets_lib.dart";

class Content extends StatelessWidget {
  final String title;
  final Widget body;

  const Content({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: CustomAppBar(
        title: title,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Builder(builder: (ctx) {
              return body;
            }),
          ],
        ),
      ),
    );
  }
}
