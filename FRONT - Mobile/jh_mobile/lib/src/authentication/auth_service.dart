part of '_authentication_lib.dart';

class AuthService {
  // Função para pegar o atual usuario logado
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Metodo de login
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeView()));
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Nenhum usuario encontrado com esse email.';
      } else if (e.code == 'wrong-password') {
        message = 'Senha incorreta';
      } else {
        message = 'Erro ao fazer login. Tente novamente.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> loginWithGoogle({
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();

      await Future.delayed(const Duration(milliseconds: 500));

      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (_firebaseAuth.currentUser != null) {
        if (context.mounted) {
          // Redireciona para a HomeView e remove a tela de login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeView(),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Erro ao fazer login com provedor: $e");
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      if (e is FirebaseAuthException) {
        if (e.code == 'admin-restricted-operation') {
          Fluttertoast.showToast(
            msg:
                "Você não tem permissão para acessar o aplicativo, fale com um administrador",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Erro ao tentar fazer login com o gmail. Tente novamente.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    }
  }

  // Metodo de deslogar
  Future<void> signout({required BuildContext context}) async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Erro ao deslogar: $e");
    }
  }
}
