import 'package:flutter/material.dart';
import 'routes/router.dart' as router;
import 'package:topmenu_app/routes/app_routes.dart';

class TopMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopMenu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      onGenerateRoute: router.generateRoute,
      initialRoute: AppRoutes.ROOT,
    );
  }
}