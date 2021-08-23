import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerse_app/models/product_model.dart';
import 'package:ecomerse_app/models/purchase_model.dart';

class DBFirebase {
  static final String _collectionAdmin = 'Admins';
  static final String _collectionProduct = 'ProdcutsPB01';
  static final String _collectionPurchase = 'PurchasePB01';
  static final String _collectionOrder = 'OrdersPB01';
  static final String _collectionCategory = 'Categories';

  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<int> checkUserAsAdmin(String uid) async {
    final snapshot = await _db
        .collection(_collectionAdmin)
        .where('adminId', isEqualTo: uid)
        .get();
    return snapshot.docs.length;
  }

  static Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    final batch = _db.batch();
    final docProduct = _db.collection(_collectionProduct).doc();
    final docPurchase = _db.collection(_collectionPurchase).doc();
    productModel.id = docProduct.id;
    purchaseModel.id = docPurchase.id;
    purchaseModel.productId = productModel.id;
    batch.set(docProduct, productModel.toMap());
    batch.set(docPurchase, purchaseModel.toMap());
    return batch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() =>
      _db.collection(_collectionCategory).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getProduct() =>
      _db.collection(_collectionProduct).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPurchaseHistory() =>
      _db.collection(_collectionPurchase).snapshots();
}
