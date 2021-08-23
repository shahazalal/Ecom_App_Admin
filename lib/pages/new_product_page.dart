import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerse_app/models/product_model.dart';
import 'package:ecomerse_app/models/purchase_model.dart';
import 'package:ecomerse_app/providers/product_provider.dart';
import 'package:ecomerse_app/utils/constant.dart';
import 'package:ecomerse_app/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static final String routeName = '/new_product';

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();
  late ProductProvider provider;
  ProductModel productModel = ProductModel();
  String? category;
  DateTime? dateTime;
  ImageSource imageSource = ImageSource.camera;
  String? imagePath;
  bool isUploading = false;
  @override
  void didChangeDependencies() {
    provider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: isUploading ? null : _saveProduct,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Product Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyTextFieldMsg;
                }
                return null;
              },
              onSaved: (value) {
                productModel.name = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Description(optional)'),
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                productModel.description = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Product Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyTextFieldMsg;
                }
                if (num.parse(value) < 0) {
                  return 'Price cannot be less Than Zero';
                }
                return null;
              },
              onSaved: (value) {
                productModel.price = num.parse(value!);
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Product Quantity'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyTextFieldMsg;
                }
                if (int.parse(value) < 0) {
                  return 'Quantity cannot be less Than Zero';
                }
                return null;
              },
              onSaved: (value) {
                productModel.stock = int.parse(value!);
              },
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.blue,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  hint: Text('Select Category'),
                  isExpanded: true,
                  value: category,
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                    productModel.category = category;
                  },
                  items: provider.categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.amber,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text('Select Date'),
                      onPressed: _showCalender,
                    ),
                    Text(
                      dateTime == null
                          ? 'No date found'
                          : DateFormat('dd/MM/yyyy').format(dateTime!),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.red.shade200,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      child: imagePath == null
                          ? Text('No Image')
                          : Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              imageSource = ImageSource.camera;
                              _getPhoto();
                            },
                            child: Text('Capture')),
                        ElevatedButton(
                            onPressed: () {
                              imageSource = ImageSource.gallery;
                              _getPhoto();
                            },
                            child: Text('Select'))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProduct() {
    if (category == null) {
      showMessage(context, 'Select a category');
      return;
    }
    if (dateTime == null) {
      showMessage(context, 'Select a purchase date');
      return;
    }
    if (imagePath == null) {
      showMessage(context, 'Capture or Select an image');
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(productModel);
      final purchaseModel = PurchaseModel(
          productName: productModel.name,
          qty: productModel.stock,
          timestamp: productModel.purchaseDate);
      provider.addNewProduct(productModel, purchaseModel).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        print(error.toString());
        showMessage(context, 'failed to save');
      });
    }
  }

  void _showCalender() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    setState(() {
      dateTime = dt;
    });
    if (dateTime != null) {
      productModel.purchaseDate = Timestamp.fromDate(dateTime!);
    }
  }

  void _getPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 75);
    if (pickedFile != null) {
      showMessage(context, 'Uploading image..');
      setState(() {
        isUploading = true;
        imagePath = pickedFile.path;
      });
      final photoDir = 'FlutterPb01/${DateTime.now().toIso8601String()}';
      final photoRef = FirebaseStorage.instance.ref().child(photoDir);
      final uploadTask = photoRef.putFile(File(imagePath!));
      final snapshot = await uploadTask.whenComplete(() {
        showMessage(context, 'Upload Completed');
      });
      final downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isUploading = false;
      });
      productModel.localImagePath = imagePath;
      productModel.cloudImagePath = photoDir;
      productModel.imageDownloadUrl = downloadUrl;
    }
  }
}
