import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_demo_project/models/products.dart';
import 'package:ecommerce_demo_project/models/shopping_cart.dart';
import 'costumer.dart';

class CostumerOrder {
  final List<ShoppingCart>? cartList;
  final String costumerEmail;
  final String costumerId;
  final String? costumerDisplayName;
  final double totalSum;
  final Timestamp orderDate;

  CostumerOrder({
    required this.cartList,
    required this.costumerEmail,
    required this.costumerId,
    required this.costumerDisplayName,
    required this.totalSum,
    required this.orderDate,
  });

  factory CostumerOrder.fromJson(Map<String, dynamic> map) {

    var jsonToProduct = map['product'] as List;

    List<ShoppingCart> productData = jsonToProduct
        .map((productAsJson) => ShoppingCart.fromJson(map: productAsJson))
        .toList();

    return CostumerOrder(
      cartList: productData,
      totalSum: map['totalSum'],
      costumerId: map['costumerId'],
      costumerDisplayName: map['costumerDisplayName'],
      costumerEmail: map['costumerEmail'],
      orderDate: map['purchaseDate'],
    );
  }

  Map<String, dynamic> toJson() {
    /// toJson Map objesi aldığı için product'ı map'e dönüştürdük.
    List<Map<String, dynamic>> newCart =
        this.cartList!.map((cart) => cart.toJson()).toList();

    return {
      'product': newCart,
      'totalSum': totalSum,
      'costumerId': costumerId,
      'costumerDisplayName': costumerDisplayName,
      'costumerEmail': costumerEmail,
      'purchaseDate': orderDate,
    };
  }
}
