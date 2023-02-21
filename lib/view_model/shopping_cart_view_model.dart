import 'package:flutter/material.dart';
import '../models/products.dart';
import '../models/shopping_cart.dart';

class ShoppingCartViewModel extends ChangeNotifier {
  List<ShoppingCart>? shoppingCartList;

  void addTheCarts(Products products, String userId) {
    shoppingCartList?.add(ShoppingCart(
        cartId: userId,
        productName: products.productName,
        price: products.price,
        productId: products.productId,
        type: products.type,
        productPhoto: products.productPhoto,
        stock: products.stock,
        quantity: null));
  }

  List<ShoppingCart>? getTheCarts() {
    return shoppingCartList;
  }

  void clearTheCarts() {
    shoppingCartList?.clear();
  }

  void deleteTheCarts({required int index}) {
    shoppingCartList?.removeAt(index);
  }
}
