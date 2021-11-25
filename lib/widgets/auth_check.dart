import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/pages/login_page.dart';
import 'package:topmenu_app/pages/root_page.dart';
import 'package:topmenu_app/services/auth_service.dart';

class AuthCheck extends StatefulWidget {

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
      return RootPage();
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
