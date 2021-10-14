import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/menus_service.dart';

class MenuTile extends StatefulWidget {
  final Menu menu;

  MenuTile(this.menu);

  @override
  _MenuTileState createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bannerUrlController = TextEditingController();
  bool _isSaving = false;

  _showEditingMenu() {
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _updateMenu();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            )
          ],
        );
      },
    );
  }

  _updateMenu() async {
    String title = _titleController.text;
    String bannerUrl = _bannerUrlController.text;
    setState(() => this._isSaving = true);
    try {
      await context.read<MenusService>().update(
            Menu(
              id: widget.menu.id,
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

  _deleteMenu() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Excluir Menu'),
        content: Text('Tem certeza?'),
        actions: [
          TextButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Sim'),
            onPressed: () async {
              await Provider.of<MenusService>(
                context,
                listen: false,
              ).remove(widget.menu);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isSaving
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.ITEM,
                  arguments: widget.menu,
                );
              },
              contentPadding: EdgeInsets.all(16.0),
              leading: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: (widget.menu.bannerUrl == '')
                      ? Image.asset('assets/images/placeholder_food.png')
                      : Image.network('${widget.menu.bannerUrl}'),
                ),
              ),
              title: Text(
                '${widget.menu.title}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'Alterar',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Alterar'),
                      onTap: () {
                        Navigator.pop(context, 'Alterar');
                        _showEditingMenu();
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Excluir',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Excluir'),
                      onTap: () {
                        Navigator.pop(context, 'Excluir');
                        _deleteMenu();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
