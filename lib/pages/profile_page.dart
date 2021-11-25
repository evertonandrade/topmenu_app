import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _photoUrlController = TextEditingController();
  String avatarDefault =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  User? user;

  @override
  void initState() {
    super.initState();
  }

  _updateProfile() async {
    setState(() => this._isLoading = true);
    try {
      final auth = context.read<AuthService>();
      await auth.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
      );
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
    var user = Provider.of<AuthService>(context).user;
    _nameController.text = user?.displayName as String;
    _emailController.text = user?.email as String;
    _photoUrlController.text = user?.photoURL ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.SETTINGS,
              );
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  padding: EdgeInsets.only(left: 16, top: 24, right: 16),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                )
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "${user?.photoURL ?? avatarDefault}",
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                color: Colors.deepOrange,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Nome de Usuário',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Digite seu nome',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'E-mail',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Digite seu email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: TextField(
                        controller: _photoUrlController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Foto de Perfil',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Cole a URL da imagem',
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
                            _updateProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'ATUALIZAR',
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
            ),
    );
  }
}
