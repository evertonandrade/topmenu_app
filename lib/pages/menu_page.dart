import 'package:flutter/material.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/services/menus_service.dart';
import 'package:topmenu_app/widgets/menu_tile.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bannerUrlController = TextEditingController();
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    getAllMenus();
  }

  getAllMenus() async {
    setState(() => this._isLoading = true);
    try {
      await context.read<MenusService>().getAll();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  _showScreenRegister() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar cardápio"),
          content: _isSaving
              ? Center(child: CircularProgressIndicator())
              : Column(
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
                          labelText: "Banner",
                          hintText: "Digite a url do banner"),
                    ),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _saveMenu();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            )
          ],
        );
      },
    );
  }

  _saveMenu() async {
    String title = _titleController.text;
    String bannerUrl = _bannerUrlController.text;
    setState(() => this._isSaving = true);
    try {
      await context.read<MenusService>().save(
            Menu(
              title: title,
              bannerUrl: bannerUrl,
              isActive: true,
              updatedAt: DateTime.now(),
            ),
          );
      _titleController.clear();
      _bannerUrlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => this._isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final menus = Provider.of<MenusService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápios'),
      ),
      body: _isLoading || _isSaving
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: menus.count,
                itemBuilder: (ctx, i) => MenuTile(menus.byIndex(i)),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _showScreenRegister();
        },
      ),
    );
  }
}
