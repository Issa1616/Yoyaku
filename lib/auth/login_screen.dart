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

    showMessage("Usuario registrado exitosamente");
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Column(
              children: [
                /// LOGO
                const Icon(
                  Icons.calendar_month,
                  size: 70,
                  color: Color(0xFF6C63FF),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Yoyaku",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                /// CARD LOGIN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),

                  child: Column(
                    children: [
                      /// SOLO EN REGISTRO
                      if (!isLogin)
                        TextField(
                          controller: name,
                          decoration: const InputDecoration(
                            labelText: "Nombre",
                          ),
                        ),

                      TextField(
                        controller: email,
                        decoration: const InputDecoration(labelText: "Correo"),
                      ),

                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Contraseña",
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : (isLogin ? login : register),
                          child: loading
                              ? const CircularProgressIndicator()
                              : Text(
                                  isLogin ? "Iniciar sesión" : "Registrarse",
                                ),
                        ),
                      ),

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
    );
  }
}
