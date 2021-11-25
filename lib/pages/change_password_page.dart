import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  _updatePassword() async {
    setState(() => this._isLoading = true);
    try {
      final auth = context.read<AuthService>();
      await auth.user?.updatePassword(_newPasswordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => this._isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar senha'),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.SETTINGS,
            );
          },
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 16, top: 34, right: 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: TextField(
                controller: _oldPasswordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Senha Atual',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Digite sua senha atual',
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: TextField(
                controller: _newPasswordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: 'Nova Senha',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Digite sua nova senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updatePassword();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'CONFIRMAR',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
