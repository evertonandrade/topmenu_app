import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/pages/login_page.dart';
import 'package:topmenu_app/services/auth_service.dart';
import 'package:topmenu_app/topmenu_app.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading)
      return loading();
    else if (auth.user == null)
      return LoginPage();
    else
      return TopMenuApp();
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
