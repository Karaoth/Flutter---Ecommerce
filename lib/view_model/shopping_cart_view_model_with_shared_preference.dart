import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/products.dart';
import '../models/shopping_cart.dart';

/// Shopping Cart bilgisini Shared_Preference kullanarak oluşturdum.
class ShoppingCartViewModelWithSharedPref extends ChangeNotifier {
  late SharedPreferences _sharedRef;

  /// Burada count ve quantity bilgisini sürekli güncelleyerek shoppingCart'a yazdırmam gerekiyor
  int _count = 0;
  int _quantity = 1;
  List<Products> _saveProductList = [];
  List<Products> _loadProductList = [];
  List<ShoppingCart> _loadShoppingCartList = [];
  List<ShoppingCart> _saveShoppingCartList = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  List<ShoppingCart> get saveShoppingCartList {
    return _saveShoppingCartList;
  }

  int get count {
    return _count;
  }

  int get quantity => _quantity;

  Future<void> saveAsSharedPreference(Products product, String userId) async {
    _sharedRef = await SharedPreferences.getInstance();
    _saveProductList.add(product);

    /// burada veriyi order'a yazdırmayı düşünüyorum. böylece quantity ve stock değerlerini
    /// dinamik olarak kullanabilirim.
    _saveShoppingCartList.add(ShoppingCart(
      cartId: userId,
      productName: product.productName,
      price: product.price,
      productId: product.productId,
      type: product.type,
      productPhoto: product.productPhoto,
      stock: product.stock,
      quantity: null,
    ));

    print('shopping cart length: ${_saveShoppingCartList.length}');

    //print('saveAsSharedPreference uzunluk: ${_productList.length}');
    String objectToString = json.encode(_saveShoppingCartList);

    /// veriyi string objesi olarak saklıyor.
    await _sharedRef.setString('product', objectToString);
    //print('string degeri: ${_sharedRef.getString('product')}');
    await _sharedRef.reload();
  }

  Future<List<ShoppingCart>> loadFromSharedPreference() async {
    /// _viewingProductList.clear(); yapmamın sebebi en son eklenen ürünü listeye tekrar
    /// dahil etmesi.
    _loadShoppingCartList.clear();

    _sharedRef = await SharedPreferences.getInstance();
    String? data = _sharedRef.getString('product');

    /// burada verileri product nesnesine dönüştürmek için
    /// önce map verisine çevirdik.
    if (data != null) {
      List<dynamic> dataList = json.decode(data);
      for (var item in dataList) {
        Map<String, dynamic> productDataAsMap = item as Map<String, dynamic>;
        _loadShoppingCartList.add(ShoppingCart.fromJson(map: productDataAsMap));
      }
    }
    await _sharedRef.reload();
    print('loadFromSharedPreference uzunluk: ${_loadShoppingCartList.length}');
    return _loadShoppingCartList;
  }

  Future<void> clearSharedPreference(String uId) async {
    try {
      _sharedRef = await SharedPreferences.getInstance();
      List<ShoppingCart> tempCartList = _loadShoppingCartList;

      /// burada sepette ki verileri kullanıcı id'lerine siliyoruz.
      tempCartList.removeWhere((element) => element.cartId == uId);
      await _sharedRef.setString('product', json.encode(tempCartList));
      await _sharedRef.reload();
      _loadShoppingCartList = tempCartList;
      _saveShoppingCartList = tempCartList;

    } catch (error) {
      print('error: $error');
    }
  }

  Future<void> deleteIndexOfSharedPreference(ShoppingCart? shoppingCart) async {
    _sharedRef = await SharedPreferences.getInstance();
    List<ShoppingCart> tempList = _loadShoppingCartList;
    //print('templist : ${tempList.length}');

    tempList.remove(shoppingCart);
    print('shopping cart length: ${_saveShoppingCartList.length}');
    //print('templist : ${tempList.length}');
    /// Burada save ve load savedpreference metodlarında ki listeleri sildiğin indeks'e
    /// yeniden yapılandırdım böylece tekrar fazladan  veri eklemesi olmayacak.
    _loadShoppingCartList = tempList;
    _saveShoppingCartList = tempList;
    await _sharedRef.setString('product', json.encode(tempList));
    await _sharedRef.reload();

  }

  Future<double> getTotalSumOfCart() async {
    _sharedRef = await SharedPreferences.getInstance();

    double totalSum = 0;
    List<Products> tempList = [];
    var data = _sharedRef.getString('product');

    if (data != null) {
      List<dynamic> dataList = json.decode(data);
      for (var item in dataList) {
        Map<String, dynamic> productDataAsMap = item as Map<String, dynamic>;
        tempList.add(Products.fromJson(map: productDataAsMap));
      }
    }

    for (var item in tempList) {
      totalSum += item.price * _quantity;
    }

    print('toplam tutar: $totalSum');
    return totalSum;
  }

  /*
  incrementQuantity(int index) {
    int quantity = 1;
    ShoppingCart shoppingCart = _saveShoppingCartList[index];

    /// bunu denemeliyim!!!
    ShoppingCart newshoppingCart = ShoppingCart(
      productId: shoppingCart.productId,
      productPhoto: shoppingCart.productPhoto,
      price: shoppingCart.price,
      productName: shoppingCart.productName,
      type: shoppingCart.type,
      stock: shoppingCart.stock,
      quantity: quantity++,
    );

    print('quantity: ${_saveShoppingCartList[index].quantity}');
    notifyListeners();
  }

  decrementQuantity(int index) {
    int quantity = 1;
    _saveShoppingCartList[index].quantity = quantity-- as ValueNotifier<int>?;
    notifyListeners();
  }

  ValueNotifier<int>? getQuantity(int index) {

    return _saveShoppingCartList[index].quantity;
  }
   */

}
