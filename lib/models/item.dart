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
    required this.avaliable
  });

  String get priceBRL {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(price);
  }
}
