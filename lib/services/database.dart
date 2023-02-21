import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_demo_project/models/shopping_cart.dart';
import 'package:flutter/cupertino.dart';

import '../models/products.dart';

class Database {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addDocumentToFireStore(
      {required String collectiohPath,
      required String documentPath,
      required Map<String, dynamic> map}) async {
    try {
      await _firebaseFirestore
          .collection(collectiohPath)
          .doc(documentPath)
          .set(map);
    } on FirebaseException catch (error) {
      print('Error code: ${error.code}');
      print('Error message: ${error.message}');
      rethrow;
    }
  }

  Future<void> addDocumentOfOrderToFireStore(
      {required String collectiohPath,
      required Map<String, dynamic> map}) async {
    try {
      await _firebaseFirestore.collection(collectiohPath).add(map);
    } on FirebaseException catch (error) {
      print('Error code: ${error.code}');
      print('Error message: ${error.message}');
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataListFromFirestore(
      {required String collectionPath}) {
    return _firebaseFirestore.collection(collectionPath).snapshots();
  }

  Future<void> deleteDocumentsFromFireStore(
      {required String collectionPath, required String documentPath}) async {
    await _firebaseFirestore
        .collection(collectionPath)
        .doc(documentPath)
        .delete();
  }

  void changeStockOfProductsFromFireStore(
      {required int stock,
      required String collectionPath,
      required productId}) {

    _firebaseFirestore
        .collection(collectionPath)
        .doc(productId)
        .update({'stock': stock});
  }
}
