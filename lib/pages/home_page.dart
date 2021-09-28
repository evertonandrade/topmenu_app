import 'package:flutter/material.dart';
import 'package:topmenu_app/pages/items_page.dart';
import 'package:topmenu_app/pages/location_page.dart';
import 'package:topmenu_app/pages/menu_page.dart';
import 'package:topmenu_app/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          LocationPage(),
          ItemPage(),
          SettingsPage()
        ],
        onPageChanged: setCurrentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.location_city), label: 'Estabelecimentos'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Cardápios'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_sharp), label: 'Configurações'),
        ],
        onTap: (page) {
          pc.animateToPage(page,
              duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}
