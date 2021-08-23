import 'package:ecomerse_app/pages/dashboard_page.dart';
import 'package:ecomerse_app/pages/launcher_page.dart';
import 'package:ecomerse_app/pages/login_page.dart';
import 'package:ecomerse_app/pages/new_product_page.dart';
import 'package:ecomerse_app/pages/product_list_page.dart';
import 'package:ecomerse_app/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.red, appBarTheme: AppBarTheme(elevation: 0)),
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName: (ctx) => LauncherPage(),
          LoginPage.routeName: (ctx) => LoginPage(),
          DashboardPage.routeName: (ctx) => DashboardPage(),
          NewProductPage.routeName: (ctx) => NewProductPage(),
          ProductListPage.routeName: (ctx) => ProductListPage()
        },
      ),
    );
  }
}
