import 'package:intl/intl.dart';

class Item {
  final String id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final bool? avaliable;

  const Item({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.avaliable,
  });

  factory Item.fromJson(Map<String, dynamic> data) {
    return Item(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
      avaliable: data['avaliable'] as bool,
    );
  }

  String get priceBRL {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(price);
  }
}
