import 'package:topmenu_app/models/item.dart';

const DUMMY_ITEMS = {
  '1': const Item(
      id: '1',
      name: 'Hamburger',
      description: 'hamburger completo',
      price: 15.00,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/RedDot_Burger.jpg/1200px-RedDot_Burger.jpg',
      avaliable: true),
  '2': const Item(
      id: '2',
      name: 'Hot dog',
      description: 'hot dog com purê de batata',
      price: 10.00,
      imageUrl:
          'https://img.itdg.com.br/images/recipes/000/160/242/116615/116615_original.jpg',
      avaliable: true),
  '3': const Item(
      id: '3',
      name: 'Coxinha',
      description: 'coxinha de frango',
      price: 5.00,
      imageUrl: 'https://www.sabornamesa.com.br/media/k2/items/cache/e3d995a152e18bb86fa197fdc98b26b8_L.jpg',
      avaliable: true),
  '4': const Item(
      id: '4',
      name: 'Pastel',
      description: 'pastel com recheio de queijo',
      price: 7.00,
      imageUrl:
          'https://img.itdg.com.br/tdg/images/recipes/000/020/617/354276/354276_original.jpg',
      avaliable: true),
};
