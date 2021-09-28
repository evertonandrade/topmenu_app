import 'dart:math';

import 'package:flutter/material.dart';
import 'package:topmenu_app/data/dummy_item.dart';
import 'package:topmenu_app/models/item.dart';

class ItemsService with ChangeNotifier {
  Map<String, Item> _items = {...DUMMY_ITEMS};

  List<Item> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Item byIndex(int index) {
    return _items.values.elementAt(index);
  }

  void put(Item item) {
    
    // altera ou adiciona
    if (_items.containsKey(item.id)) {
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
      final id = Random().nextInt(1000).toString();
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

  void remove(Item? item) {
    _items.remove(item?.id);
    notifyListeners();
  }
}
