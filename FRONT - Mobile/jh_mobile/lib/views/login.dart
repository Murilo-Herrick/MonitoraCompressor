part of '_views_lib.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userEmail = TextEditingController();
  final userPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool visivel = true;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/senai-escola.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/senai.png",
                            width: mediaSize.width * 0.6,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Monitoramento Compressor",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.4),
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 36),

                      // Card do login
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: userEmail,
                                label: "Email",
                                hint: "Digite seu email",
                                prefixIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha o campo de email";
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Insira um email válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: userPassword,
                                label: "Senha",
                                hint: "Digite sua senha",
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: visivel,
                                onToggleVisibility: () {
                                  setState(() {
                                    visivel = !visivel;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha o campo de senha";
                                  }
                                  if (value.length < 6) {
                                    return 'Senha deve ter pelo menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 28),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD32F2F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      elevation: 5,
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await AuthService().signin(
                                          email: userEmail.text,
                                          password: userPassword.text,
                                          context: context,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Entrar",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Não tem cadastro? Crie uma conta",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  await AuthService()
                                      .loginWithGoogle(context: context);
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SvgPicture.asset(
                                      'assets/images/google-logo.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
