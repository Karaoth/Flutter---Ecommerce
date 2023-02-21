import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_demo_project/models/costumer_order.dart';
import 'package:ecommerce_demo_project/models/shopping_cart.dart';
import 'package:flutter/material.dart';

import '../models/products.dart';
import '../services/database.dart';

class CostumerOrderViewModel extends ChangeNotifier{
  final Database _database = Database();
  final String _collectiohPath = 'order';

  addOrder({
    required List<ShoppingCart>? cartList,
    required String costumerEmail,
    required String costumerId,
    required String costumerDisplayName,
    required double totalSum,
    required Timestamp orderDate,
  }) {

    CostumerOrder newOrder = CostumerOrder(
      cartList: cartList,
      costumerEmail: costumerEmail,
      costumerId: costumerId,
      costumerDisplayName: costumerDisplayName,
      totalSum: totalSum,
      orderDate: orderDate,
    );

    _database.addDocumentOfOrderToFireStore(
        collectiohPath: _collectiohPath, map: newOrder.toJson());
  }

  Stream<List<CostumerOrder>> getOrderListFromApi() {

    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =  _database
        .getDataListFromFirestore(collectionPath: _collectiohPath);

    Stream<List<CostumerOrder>>  costumerOrder =  querySnapshot
        .map((event) => event.docs)
        .map((event) => event.map((e) => CostumerOrder.fromJson(e.data())).toList());

    return costumerOrder;
  }
}
