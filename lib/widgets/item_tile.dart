import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/item.dart';
import 'package:topmenu_app/services/items_service.dart';

class ItemTile extends StatefulWidget {
  final Item? item;
  final String idMenu;
  final String idCategory;

  ItemTile(this.item, this.idMenu, this.idCategory);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final _form = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};
  bool _isLoading = false;

  _showEditingModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.item?.name,
                  decoration: InputDecoration(labelText: 'Nome'),
                  onSaved: (value) => _formData['name'] = value.toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nome Inválido';
                    if (value.trim().length <= 3) return 'Nome muito curto';
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: widget.item?.description,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                  ),
                  onSaved: (value) =>
                      _formData['description'] = value.toString(),
                ),
                TextFormField(
                  initialValue: widget.item?.price.toString(),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Preço',
                  ),
                  onSaved: (value) => _formData['price'] = value ?? 0.00,
                ),
                TextFormField(
                  initialValue: widget.item?.imageUrl,
                  decoration: InputDecoration(
                    labelText: 'URL da Imagem',
                  ),
                  onSaved: (value) => _formData['imageUrl'] = value ?? 0.00,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (_isLoading)
                        ? [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]
                        : [
                            Icon(Icons.arrow_upward_outlined),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Atualizar',
                              ),
                            ),
                          ],
                  ),
                  onPressed: () {
                    _updateItem();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _updateItem() async {
    final isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      _form.currentState?.save();
      setState(() => _isLoading = true);
      await Provider.of<ItemsService>(context, listen: false).update(
        widget.idMenu,
        widget.idCategory,
        Item(
          id: widget.item?.id ?? '',
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
  }

  _deleteItem() async {
    await Provider.of<ItemsService>(
      context,
      listen: false,
    ).remove(widget.idMenu, widget.idCategory, widget.item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: (widget.item?.imageUrl == null || widget.item?.imageUrl == '')
              ? Image.asset('assets/images/placeholder_food.png')
              : Image.network('${widget.item?.imageUrl}'),
        ),
      ),
      title: Text(widget.item?.name ?? ''),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.item?.description}'),
          Text(
            '${widget.item?.priceBRL}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      isThreeLine: true,
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.grey[800],
              onPressed: () {
                _showEditingModal();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.deepOrange,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir Item'),
                    content: Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        child: Text('Não'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Sim'),
                        onPressed: () {
                          _deleteItem();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
