import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/category.dart';
import 'package:topmenu_app/models/menu.dart';
import 'package:topmenu_app/services/categories_service.dart';
import 'package:topmenu_app/widgets/category_tile.dart';

class CategoryPage extends StatefulWidget {
  final Menu menu;

  CategoryPage(this.menu);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _isLoading = false;
  bool _isSaving = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _backgroundUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  _getAllCategories() async {
    if (mounted) setState(() => this._isLoading = true);
    try {
      final serviceCategory = context.read<CategoriesService>();
      serviceCategory.clear();
      await serviceCategory.getAll(widget.menu.id as String);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  _saveCategory() async {
    final idMenu = widget.menu.id as String;
    String title = _titleController.text;
    String backgroundUrl = _backgroundUrlController.text;
    setState(() => this._isSaving = true);
    try {
      await context.read<CategoriesService>().save(
            idMenu,
            Category(
              title: title,
              backgroundUrl: backgroundUrl,
              updatedAt: DateTime.now(),
              idMenu: widget.menu.id,
            ),
          );
      _titleController.clear();
      _backgroundUrlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => this._isSaving = false);
    }
  }

  _showScreenRegister() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar categoria"),
          content: _isSaving
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Título",
                        hintText: "Digite o título",
                      ),
                    ),
                    TextField(
                      controller: _backgroundUrlController,
                      decoration: InputDecoration(
                        labelText: "Background",
                        hintText: "Digite a url do background",
                      ),
                    ),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _saveCategory();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoriesService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        actions: [
          IconButton(
            onPressed: () {
              _showScreenRegister();
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: categories.count,
                itemBuilder: (ctx, i) =>
                    CategoryTile(categories.byIndex(i), widget.menu.id),
              ),
            ),
    );
  }
}
