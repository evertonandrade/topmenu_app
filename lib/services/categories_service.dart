import 'package:flutter/material.dart';
import 'package:topmenu_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:topmenu_app/shared/config.dart';
import 'dart:convert';

class CategoriesService with ChangeNotifier {
  Map<String, Category> _categories = {};

  int get count => _categories.length;

  List<Category> get all => [..._categories.values];

  Category byIndex(int index) => _categories.values.elementAt(index);

  clear() {
    _categories = {};
  }

  Future getAll(String idMenu) async {
    var path = 'menus/$idMenu/categories.json';
    var response = await http.get(Uri.https(Config.baseUrl, path));
    final categories = jsonDecode(response.body);
    if (categories != null) {
      categories.forEach((key, value) {
        value['id'] = key;
        _categories[key] = Category.fromJson(value);
      });
    }

    notifyListeners();
  }

  Future<void> save(String idMenu, Category category) async {
    var path = 'menus/$idMenu/categories.json';
    var response = await http.post(
      Uri.https(Config.baseUrl, path),
      body: jsonEncode(
        {
          'title': category.title,
          'bannerUrl': category.backgroundUrl,
          'updatedAt': category.updatedAt!.toIso8601String(),
          'idMenu': category.idMenu
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _categories.putIfAbsent(
      id,
      () => Category(
        id: id,
        title: category.title,
        backgroundUrl: category.backgroundUrl,
        updatedAt: category.updatedAt,
        idMenu: category.idMenu,
      ),
    );

    notifyListeners();
  }

  Future<void> remove(String idMenu, Category category) async {
    var path = 'menu/$idMenu/categories/${category.id}.json';
    http.delete(
      Uri.https(
        Config.baseUrl,
        path,
      ),
    );
    _categories.remove(category.id);
    notifyListeners();
  }
}
