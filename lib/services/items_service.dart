import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:topmenu_app/models/item.dart';
import 'package:topmenu_app/shared/config.dart';

class ItemsService with ChangeNotifier {
  Map<String, Item> _items = {};
  String idMenu = '';

  setIdMenu(dynamic id) {
    idMenu = id;
    notifyListeners();
  }

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

  Future getAll() async {
    var path = 'menus/' + idMenu + '/items.json';
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

  Future<void> put(Item item) async {
    // altera ou adiciona
    if (_items.containsKey(item.id)) {
      await http.patch(
        Uri.https(
          Config.baseUrl,
          'menus/${idMenu}/items/${item.id}.json',
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
    } else {
      final response = await http.post(
        Uri.https(
          Config.baseUrl,
          'menus/${idMenu}/items.json',
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
    }

    notifyListeners();
  }

  Future<void> remove(Item? item) async {
    http.delete(
      Uri.https(
        Config.baseUrl,
        'menus/${idMenu}/items/${item?.id}.json',
      ),
    );
    _items.remove(item?.id);
    notifyListeners();
  }
}
