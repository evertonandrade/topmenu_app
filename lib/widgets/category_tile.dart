import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/category.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/categories_service.dart';

class CategoryTile extends StatefulWidget {
  final Category category;
  final String? idMenu;

  CategoryTile(this.category, this.idMenu);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  _deleteCategory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Excluir Categoria'),
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
              var idMenu = widget.idMenu as String;
              var category = widget.category;
              await Provider.of<CategoriesService>(
                context,
                listen: false,
              ).remove(idMenu, category);
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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            image: NetworkImage('${widget.category.backgroundUrl}'),
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.modulate),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.ITEM,
                  arguments: widget.category,
                );
              },
              onLongPress: () {
                _deleteCategory();
              },
            ),
            height: 120,
            fit: BoxFit.cover,
          ),
          Text(
            '${widget.category.title}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
