import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/category.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/items_service.dart';
import 'package:topmenu_app/widgets/item_tile.dart';

class ItemPage extends StatefulWidget {
  final Category category;

  ItemPage(this.category);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  getAllItems() async {
    if (mounted) setState(() => this._isLoading = true);
    try {
      var idMenu = widget.category.idMenu as String;
      var idCategory = widget.category.id as String;
      final serviceItems = context.read<ItemsService>();
      serviceItems.clear();
      await serviceItems.getAll(idMenu, idCategory);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ItemsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.ITEM_FORM,
                arguments: widget.category,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: items.count,
                itemBuilder: (ctx, i) => ItemTile(
                  items.byIndex(i),
                  widget.category.idMenu as String,
                  widget.category.id as String,
                ),
              ),
            ),
    );
  }
}
