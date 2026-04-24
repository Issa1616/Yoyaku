import 'package:flutter/material.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = AuthController();

  bool loading = false;
  bool obscure = true;

  void login() async {
    setState(() => loading = true);

    final error = await auth.login(email.text.trim(), password.text.trim());

    setState(() => loading = false);

    if (error != null) {
      showMessage(error);
      return;
    }

    showMessage("Inicio de sesión exitoso");
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 128, 145, 84),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Image.asset("assets/logito.png", height: 120),

                  const SizedBox(height: 15),

                  const Text(
                    "Iniciar sesión",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.85),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black12,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            hintText: "Correo electrónico",
                            prefixIcon: const Icon(Icons.mail_outline),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 219, 221, 217),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          controller: password,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 219, 221, 217),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: loading ? null : login,
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9BC59D),
                                    Color(0xFF1E4633),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: Color.fromARGB(
                                          255,
                                          128,
                                          145,
                                          84,
                                        ),
                                      )
                                    : const Text(
                                        "Entrar",
                                        style: TextStyle(
                                          color: Color(0xFF1E4633),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 8),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Regístrate",
                      style: TextStyle(
                        color: Color(0xFF1E4633),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
