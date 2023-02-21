import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/products.dart';
import '../services/database.dart';

class ProductViewModel extends ChangeNotifier {
  final Database _database = Database();
  final String _collectionReference = 'products';

  Stream<List<Products>> getProductsList() {
    try {
      Stream<List<DocumentSnapshot<Map<String, dynamic>>>> documentSnapshot =
          _database
              .getDataListFromFirestore(collectionPath: _collectionReference)
              .map(
                (querySnap) => querySnap.docs,
              );

      Stream<List<Products>> productList = documentSnapshot.map(
        (documentSnap) => documentSnap
            .map((mapData) => Products.fromJson(map: mapData.data()))
            .toList(),
      );

      return productList;
    } on FirebaseException catch (error) {
      print('ProductView Model Eklemede Hata Meydana Geldi');
      rethrow;
    }
  }


  void updateProduct(
      {required String documentId,
      required int price,
      required String productName,
      required String productId,
      required String productPhoto,
      required String type,
      required int quantity}) {
    Products newProduct = Products(
        productName: productName,
        price: price,
        productId: productId,
        type: type,
        productPhoto: productPhoto,
        stock: quantity);

    _database.addDocumentToFireStore(
        collectiohPath: _collectionReference,
        documentPath: documentId,
        map: newProduct.toJson());
  }

  Future<void> addtoProduct({required Map<String, dynamic> map, required documentPath}) async {

    await _database.addDocumentToFireStore(
        collectiohPath: _collectionReference,
        documentPath: documentPath,
        map: map);
  }

  Future<void> deleteToProduct(Products products) async {



    _database.deleteDocumentsFromFireStore(
        collectionPath: _collectionReference, documentPath: products.productId);
  }
}
