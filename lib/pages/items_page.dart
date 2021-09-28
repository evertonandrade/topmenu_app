import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/item.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/services/items_service.dart';
import 'package:topmenu_app/widgets/item_tile.dart';

class ItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ItemsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Items do Cardápio'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.ITEM_FORM);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.count,
        itemBuilder: (ctx, i) => ItemTile(items.byIndex(i)),
      ),
    );
  }
}
