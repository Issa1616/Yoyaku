import 'package:flutter/material.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final auth = AuthController();

  bool loading = false;
  bool isLogin = true;
  bool obscure = true;

  /// LOGIN
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

  void register() async {
    setState(() => loading = true);

    final error = await auth.register(
      name.text.trim(),
      email.text.trim(),
      password.text.trim(),
    );

    setState(() => loading = false);

    if (error != null) {
      showMessage(error);
      return;
    }

    showMessage("Usuario registrado correctamente");
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
            colors: [Colors.white, Color(0xFF809154)],
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
                  /// LOGO
                  Image.asset("assets/logito.png", height: 120),

                  const SizedBox(height: 20),

                  Text(
                    isLogin ? "Iniciar sesión" : "Crear cuenta",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: Column(
                      children: [
                        if (!isLogin)
                          Column(
                            children: [
                              TextField(
                                controller: name,
                                decoration: input("Nombre", Icons.person),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        TextField(
                          controller: email,
                          decoration: input(
                            "Correo electrónico",
                            Icons.mail_outline,
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          controller: password,
                          obscureText: obscure,
                          decoration: input("Contraseña", Icons.lock_outline)
                              .copyWith(
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
                              ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : (isLogin ? login : register),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF809154),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),

                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    isLogin ? "Entrar" : "Registrarse",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? "¿No tienes cuenta? Regístrate"
                                : "Ya tengo cuenta",
                          ),
                        ),
                      ],
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

  InputDecoration input(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFDBDDD9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
