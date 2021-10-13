import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/pages/items_page.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/menus_service.dart';

class MenuTile extends StatefulWidget {
  final Menu menu;

  MenuTile(this.menu);

  @override
  _MenuTileState createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  _alterarMenu() {}

  _excluirMenu() {
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
    return Card(
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
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Alterar'),
                onTap: () {
                  _alterarMenu();
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
                  _excluirMenu();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
