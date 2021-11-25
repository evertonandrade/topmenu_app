import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:topmenu_app/models/item.dart';
import 'package:topmenu_app/shared/config.dart';

class ItemsService with ChangeNotifier {
  Map<String, Item> _items = {};

  clear() {
    _items = {};
  }

  List<Item> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Item byIndex(int index) {
    return _items.values.elementAt(index);
  }

  Future getAll(String idMenu, String idCategory) async {
    var path = 'menus/$idMenu/categories/$idCategory/items.json';
    var response = await http.get(
      Uri.https(Config.baseUrl, path),
    );
    final items = jsonDecode(response.body);
    if (items != null) {
      items.forEach((key, value) {
        value['id'] = key;
        _items[key] = Item.fromJson(value);
      });
    }
    notifyListeners();
  }

  Future<void> save(String idMenu, String idCategory, Item item) async {
    var path = 'menus/$idMenu/categories/$idCategory/items.json';
    final response = await http.post(
      Uri.https(
        Config.baseUrl,
        path,
      ),
      body: json.encode({
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'avaliable': item.avaliable,
      }),
    );

    final id = json.decode(response.body)['name'];

    _items.putIfAbsent(
      id,
      () => Item(
        id: id,
        name: item.name,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        avaliable: item.avaliable,
      ),
    );

    notifyListeners();
  }

  Future<void> update(String idMenu, String idCategory, Item item) async {
    var path = 'menus/$idMenu/categories/$idCategory/items/${item.id}.json';
    if (_items.containsKey(item.id)) {
      await http.patch(
        Uri.https(
          Config.baseUrl,
          path,
        ),
        body: json.encode({
          'name': item.name,
          'description': item.description,
          'price': item.price,
          'imageUrl': item.imageUrl,
          'avaliable': item.avaliable,
        }),
      );
      _items.update(
        item.id,
        (_) => Item(
          name: item.name,
          description: item.description,
          price: item.price,
          imageUrl: item.imageUrl,
          avaliable: item.avaliable,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> remove(String idMenu, String idCategory, Item? item) async {
    var path = 'menus/$idMenu/categories/$idCategory/items/${item?.id}.json';
    http.delete(
      Uri.https(
        Config.baseUrl,
        path,
      ),
    );
    _items.remove(item?.id);
    notifyListeners();
  }
}
