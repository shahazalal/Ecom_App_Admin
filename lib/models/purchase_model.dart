import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  String? id;
  String? productName;
  String? productId;
  int? qty;
  Timestamp? timestamp;

  PurchaseModel(
      {this.id, this.productName, this.productId, this.qty, this.timestamp});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'productId': productId,
      'productName': productName,
      'qty': qty,
      'timestamp': timestamp,
    };
    return map;
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
        id: map['id'],
        productId: map['productId'],
        productName: map['productName'],
        qty: map['qty'],
        timestamp: map['id'],
      );

  @override
  String toString() {
    return 'PurchaseModel{id: $id, productName: $productName, productId: $productId, qty: $qty, timestamp: $timestamp}';
  }
}
