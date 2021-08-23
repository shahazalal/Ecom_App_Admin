import 'package:ecomerse_app/db/db_firebase.dart';
import 'package:ecomerse_app/models/product_model.dart';
import 'package:ecomerse_app/models/purchase_model.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  List<String> categories = [];
  List<ProductModel> products = [];
  List<PurchaseModel> purchaseList = [];
  void getCategories() {
    DBFirebase.getCategories().listen((snapshot) {
      categories = List.generate(
          snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      print(categories);
      notifyListeners();
    });
  }

  void getProducts() {
    DBFirebase.getProduct().listen((snapshot) {
      products = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      print(products);
      notifyListeners();
    });
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DBFirebase.addNewProduct(productModel, purchaseModel);
  }
}
