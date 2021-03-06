import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/category.dart';
import 'package:topmenu_app/models/item.dart';
import 'package:topmenu_app/services/items_service.dart';

class ItemForm extends StatefulWidget {
  final Category category;

  ItemForm(this.category);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final isValid = _form.currentState?.validate() ?? false;
              if (isValid) {
                _form.currentState?.save();
                setState(() => _isLoading = true);
                await Provider.of<ItemsService>(context, listen: false).save(
                  widget.category.idMenu as String,
                  widget.category.id as String,
                  Item(
                    name: _formData['name'].toString(),
                    description: _formData['description'].toString(),
                    price: double.tryParse(_formData['price'].toString()),
                    imageUrl: _formData['imageUrl'].toString(),
                    avaliable: true,
                  ),
                );
                setState(() => _isLoading = false);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Nome Inv??lido';
                        if (value.trim().length <= 3) return 'Nome muito curto';
                        return null;
                      },
                      onSaved: (value) => _formData['name'] = value.toString(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: 'Descri????o'),
                      onSaved: (value) =>
                          _formData['description'] = value.toString(),
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Pre??o'),
                      onSaved: (value) => _formData['price'] = value ?? 0.00,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      onSaved: (value) => _formData['imageUrl'] = value ?? 0.00,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
