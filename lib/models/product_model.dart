import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? name;
  String? category;
  num? price;
  String? localImagePath;
  String? cloudImagePath;
  String? imageDownloadUrl;
  String? description;
  int? stock;
  bool? isAvailable;
  Timestamp? purchaseDate;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.localImagePath,
      this.imageDownloadUrl,
      this.cloudImagePath,
      this.description,
      this.stock,
      this.isAvailable = true,
      this.purchaseDate});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'localImagePath': localImagePath,
      'cloudImagePath': cloudImagePath,
      'imageDownloadUrl': imageDownloadUrl,
      'description': description,
      'stock': stock,
      'isAvailable': isAvailable,
      'purchaseDate': purchaseDate
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      price: map['price'],
      localImagePath: map['localImagePath'],
      cloudImagePath: map['cloudImagePath'],
      imageDownloadUrl: map['imageDownloadUrl'],
      description: map['description'],
      stock: map['stock'],
      isAvailable: map['isAvailable'],
      purchaseDate: map['purchaseDate']);

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, category: $category, price: $price, localImagePath: $localImagePath, cloudImagePath: $cloudImagePath, imageDownloadUrl: $imageDownloadUrl, description: $description, stock: $stock, isAvailable: $isAvailable, purchaseDate: $purchaseDate}';
  }
}
