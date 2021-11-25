import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool _loading = false;

  register() async {
    setState(() => _loading = true);
    try {
      await context
          .read<AuthService>()
          .register(name.text, email.text, password.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  _goToLogin() {
    Navigator.pushNamed(context, AppRoutes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Crie sua conta!',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        (value!.isEmpty) ? 'Informe seu nome de usuário' : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,

                  ),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value!.isEmpty)
                        ? 'Informe o email corretamente!'
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  child: TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  child: TextFormField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmar Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirme sua senha!';
                      } else if (value != password.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (_loading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              Icon(Icons.app_registration),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Cadastrar',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _goToLogin(),
                  child: Text('Voltar ao login.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
