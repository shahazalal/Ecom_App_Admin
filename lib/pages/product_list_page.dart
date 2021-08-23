import 'package:ecomerse_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  static final String routeName = '/products';

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return ListTile(
              title: Text(product.name!),
              subtitle: Text('Stock: ${product.stock}'),
              trailing: Text('BDT: ${product.price}'),
            );
          },
        ),
      ),
    );
  }
}
