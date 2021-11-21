import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/services/google_sigin_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  login() async {
    setState(() => _loading = true);
    try {
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  loginWithGoogle() async {
    try {
      await context.read<GoogleSignInService>().signInWithGoogle();
    } on GoogleAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  _goToRegister() {
    Navigator.pushNamed(context, AppRoutes.REGISTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bem Vindo!',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
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
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login();
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
                              Icon(Icons.login),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _goToRegister(),
                  child: Text('Ainda não tem conta? Cadastre-se agora.'),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      loginWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.google),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Login com Google',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
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
