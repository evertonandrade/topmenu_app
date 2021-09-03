import 'package:flutter/material.dart';

void main() {
  runApp(TopMenuApp());
}

class TopMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TopMenu App',
      theme: ThemeData(primaryColor: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Título'),
        ),
        body: Center(
          child: Text('Conteúdo'),
        ),
      ),
    );
  }
}
