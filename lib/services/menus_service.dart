import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/shared/config.dart';

class MenusService with ChangeNotifier {
  Map<String, Menu> _menus = {};

  int get count => _menus.length;
  List<Menu> get all => [..._menus.values];
  Menu byIndex(int index) => _menus.values.elementAt(index);

  Future<void> save(Menu menu) async {
    final response = await http.post(
      Uri.https(
        Config.baseUrl,
        'menus.json',
      ),
      body: jsonEncode(
        {
          'title': menu.title,
          'bannerUrl': menu.bannerUrl,
          'isActive': menu.isActive,
          'updatedAt': menu.updatedAt!.toIso8601String(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _menus.putIfAbsent(
      id,
      () => Menu(
        id: id,
        title: menu.title,
        bannerUrl: menu.bannerUrl,
        isActive: menu.isActive,
        updatedAt: menu.updatedAt,
      ),
    );

    notifyListeners();
  }

  Future update(Menu menu) async {
    if (_menus.containsKey(menu.id)) {
      await http.patch(
        Uri.https(
          Config.baseUrl,
          'menus/${menu.id}.json',
        ),
        body: jsonEncode(
          {
            'title': menu.title,
            'bannerUrl': menu.bannerUrl,
            'isActive': menu.isActive,
            'updatedAt': menu.updatedAt!.toIso8601String(),
          },
        ),
      );
      _menus.update(
        menu.id as String,
        (_) => Menu(
          title: menu.title,
          bannerUrl: menu.bannerUrl,
          isActive: menu.isActive,
          updatedAt: menu.updatedAt,
        ),
      );
    }
    notifyListeners();
  }

  Future getAll() async {
    final response = await http.get(
      Uri.https(
        Config.baseUrl,
        'menus.json',
      ),
    );
    final menus = jsonDecode(response.body);
    if (menus != null) {
      menus.forEach((key, value) {
        value['id'] = key;
        _menus[key] = Menu.fromJson(value);
      });
    }
    notifyListeners();
  }

  Future<void> remove(Menu menu) async {
    http.delete(
      Uri.https(
        Config.baseUrl,
        'menus/${menu.id}.json',
      ),
    );
    _menus.remove(menu.id);
    notifyListeners();
  }
}
