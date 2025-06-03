part of '_authentication_lib.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao conectar ao Firebase"),
            );
          }
          else if (!snapshot.hasData) {
            return const Login();
          }
          else {
            return const HomeView();
          }
        },
      ),
    );
  }
}
