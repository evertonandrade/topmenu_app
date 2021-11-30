import 'package:flutter/material.dart';
import 'package:topmenu_app/models/category.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/pages/category_page.dart';
import 'package:topmenu_app/pages/change_password_page.dart';
import 'package:topmenu_app/pages/home_page.dart';
import 'package:topmenu_app/pages/item_form.dart';
import 'package:topmenu_app/pages/items_page.dart';
import 'package:topmenu_app/pages/login_page.dart';
import 'package:topmenu_app/pages/menu_page.dart';
import 'package:topmenu_app/pages/profile_page.dart';
import 'package:topmenu_app/pages/register_page.dart';
import 'package:topmenu_app/pages/root_page.dart';
import 'package:topmenu_app/pages/settings_page.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/widgets/auth_check.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.ROOT:
      return MaterialPageRoute(builder: (context) => AuthCheck());
    case AppRoutes.LOGIN:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case AppRoutes.REGISTER:
      return MaterialPageRoute(builder: (context) => RegisterPage());
    case AppRoutes.HOME:
      return MaterialPageRoute(builder: (context) => HomePage());
    case AppRoutes.MENU:
      return MaterialPageRoute(builder: (context) => MenuPage());
    case AppRoutes.CATEGORY:
      return MaterialPageRoute(
        builder: (context) => CategoryPage(settings.arguments as Menu),
      );
    case AppRoutes.ITEM:
      return MaterialPageRoute(
        builder: (context) => ItemPage(settings.arguments as Category),
      );
    case AppRoutes.ITEM_FORM:
      return MaterialPageRoute(
        builder: (context) => ItemForm(settings.arguments as Category),
      );
    case AppRoutes.PROFILE:
      return MaterialPageRoute(builder: (context) => ProfilePage());
    case AppRoutes.SETTINGS:
      return MaterialPageRoute(builder: (context) => SettingsPage());
    case AppRoutes.CHANGE_PASSWORD:
      return MaterialPageRoute(builder: (context) => ChangePasswordPage());
    default:
      return MaterialPageRoute(builder: (context) => RootPage());
  }
}
