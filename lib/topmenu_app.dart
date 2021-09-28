import 'package:flutter/material.dart';
import 'package:topmenu_app/pages/item_form.dart';
import 'package:topmenu_app/routes/app_routes.dart';
import 'package:topmenu_app/widgets/auth_check.dart';

class TopMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopMenu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: AuthCheck(),
      routes: {
        AppRoutes.ITEM_FORM: (ctx) => ItemForm()
      },
    );
  }
}