import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topmenu_app/models/item.dart';
import 'package:topmenu_app/services/items_service.dart';

class ItemTile extends StatelessWidget {
  final Item? item;
  final _form = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: (item?.imageUrl == null || item?.imageUrl == '')
              ? Image.asset('assets/images/placeholder_food.png')
              : Image.network('${item?.imageUrl}'),
        ),
      ),
      title: Text(item?.name ?? ''),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${item?.description}'),
          Text(
            '${item?.priceBRL}',
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
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext ctx) {
                    print(context);
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: item?.name,
                              decoration: InputDecoration(labelText: 'Nome'),
                              onSaved: (value) =>
                                  _formData['name'] = value.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Nome Inválido';
                                if (value.trim().length <= 3)
                                  return 'Nome muito curto';
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: item?.description,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelText: 'Descrição',
                              ),
                              onSaved: (value) =>
                                  _formData['description'] = value.toString(),
                            ),
                            TextFormField(
                              initialValue: item?.price.toString(),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Preço',
                              ),
                              onSaved: (value) =>
                                  _formData['price'] = value ?? 0.00,
                            ),
                            TextFormField(
                              initialValue: item?.imageUrl,
                              decoration: InputDecoration(
                                labelText: 'URL da Imagem',
                              ),
                              onSaved: (value) =>
                                  _formData['imageUrl'] = value ?? 0.00,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              child: Text('Atualizar'),
                              onPressed: () {
                                final isValid =
                                    _form.currentState?.validate() ?? false;
                                print(_form.currentState);
                                if (isValid) {
                                  _form.currentState?.save();

                                  Provider.of<ItemsService>(
                                    context,
                                    listen: false,
                                  ).put(
                                    Item(
                                      id: item?.id ?? '',
                                      name: _formData['name'].toString(),
                                      description:
                                          _formData['description'].toString(),
                                      price: double.tryParse(
                                          _formData['price'].toString()),
                                      imageUrl:
                                          _formData['imageUrl'].toString(),
                                      avaliable: true,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
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
                          Provider.of<ItemsService>(context, listen: false)
                              .remove(item);
                          Navigator.of(context).pop();
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
