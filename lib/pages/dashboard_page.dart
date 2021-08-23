import 'package:ecomerse_app/auth/firebase_auth_service.dart';
import 'package:ecomerse_app/pages/new_product_page.dart';
import 'package:ecomerse_app/pages/product_list_page.dart';
import 'package:ecomerse_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  static final String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ProductProvider provider;
  bool isInit = true;
  @override
  void didChangeDependencies() {
    provider = Provider.of<ProductProvider>(context, listen: false);
    if (isInit) {
      provider.getCategories();
      provider.getProducts();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuthService.logout().then((_) =>
                  Navigator.pushReplacementNamed(context, LoginPage.routeName));
            },
          )
        ],
        title: Text('Dashboard'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(4),
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, NewProductPage.routeName),
              child: Text('ADD PRODUCT')),
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ProductListPage.routeName),
              child: Text('VIEW PRODUCT')),
          ElevatedButton(onPressed: () {}, child: Text('VIEW ORDER')),
          ElevatedButton(onPressed: () {}, child: Text('ADD CATEGORIES')),
        ],
      ),
    );
  }
}
