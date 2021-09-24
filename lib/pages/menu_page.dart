import 'package:flutter/material.dart';
import 'package:topmenu_app/helpers/menu_helper.dart';
import 'package:topmenu_app/models/Menu.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bannerUrlController = TextEditingController();
  TextEditingController _qrCodeController = TextEditingController();
  var _db = MenuHelper();

  _exibirTelaCadastro() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicionar cardápio"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Digite o título"),
                ),
                TextField(
                  controller: _bannerUrlController,
                  decoration: InputDecoration(
                      labelText: "Banner", hintText: "Digite a url do banner"),
                ),
                TextField(
                  controller: _qrCodeController,
                  decoration: InputDecoration(
                      labelText: "Qr Code", hintText: "Digite a url qrcode"),
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    _salvarMenu();
                    Navigator.pop(context);
                  },
                  child: Text("Salvar"))
            ],
          );
        });
  }

  _salvarMenu() async {
    String title = _titleController.text;
    String bannerUrl = _bannerUrlController.text;
    String qrCode = _qrCodeController.text;

    Menu menu =
        Menu(title, bannerUrl, qrCode, "test", DateTime.now().toString());
    int resultado = await _db.salvarMenu(menu);
    print("salvar menu: " + resultado.toString());
    _titleController.clear();
    _bannerUrlController.clear();
    _qrCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápios'),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[900],
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            _exibirTelaCadastro();
          }),
    );
  }
}
