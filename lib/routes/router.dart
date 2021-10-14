import 'package:flutter/material.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/pages/home_page.dart';
import 'package:topmenu_app/pages/item_form.dart';
import 'package:topmenu_app/pages/items_page.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/widgets/auth_check.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.HOME:
      return MaterialPageRoute(builder: (context) => AuthCheck());
    case AppRoutes.ITEM:
      return MaterialPageRoute(builder: (context) => ItemPage(settings.arguments as Menu));
    case AppRoutes.ITEM_FORM:
      return MaterialPageRoute(builder: (context) => ItemForm());
    default:
      return  MaterialPageRoute(builder: (context) => HomePage());
  }
}
