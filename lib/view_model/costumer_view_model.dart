import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/costumer.dart';
import '../services/database.dart';

class CostumerViewModel extends ChangeNotifier{
  final String _collectionPath = 'costumer';
  final Database _database = Database();

  Stream<List<Costumer>> getCostumerList() {

    Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
    costumerQuerySnap = _database
        .getDataListFromFirestore(collectionPath: _collectionPath)
        .map((QuerySnapshot) => QuerySnapshot.docs);

    Stream<List<Costumer>> listOfCostumer = costumerQuerySnap.map(
            (docSnapshot) =>
            docSnapshot
                .map((docList) => Costumer.fromJson(map: docList.data()))
                .toList());

    return listOfCostumer;
  }


  void userAdd(Map<String, dynamic> map) {

    try{
      _database.addDocumentToFireStore(
          collectiohPath: _collectionPath, documentPath: map['costumerId'], map: map);
    } on FirebaseException catch(error) {
      print('error kodu: ${error.code}');
      print('error mesajı: ${error.message}');
      rethrow;
    }

  }

}
