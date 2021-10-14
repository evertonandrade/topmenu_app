import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/items_service.dart';
import 'package:topmenu_app/widgets/item_tile.dart';

class ItemPage extends StatefulWidget {
  final Menu menu;

  ItemPage(this.menu);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setMenuId();
    getAllItems();
  }

  setMenuId() {
    context.read<ItemsService>().setIdMenu(widget.menu.id);
  }

  getAllItems() async {
    setState(() => this._isLoading = true);
    try {
      final serviceItems = context.read<ItemsService>();
      serviceItems.clear();
      await serviceItems.getAll();
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

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ItemsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Items - ${widget.menu.title}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM);
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
                ),
              ),
            ),
    );
  }
}
