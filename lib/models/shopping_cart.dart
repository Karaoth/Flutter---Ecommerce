import 'package:ecommerce_demo_project/models/products.dart';

/// normalde quantity bilgisini products modeli değil shoppingCart modeli tutmalı.
/// ilerde veritabanından değişiklik yaparken bunu göz önünde bulundurmalıyım.
/// Ayrıca products modeline stok bilgisi eklemeliyim.

/// buraya cartId ekleyip bu cartId'y de uid ile olarak
/// vermem lazım böylece diğer kullanıcılar başkalarının
/// sepetine erişemez.
class ShoppingCart {
  final String cartId;
  final String productName;
  final int price;
  final String productId;
  final String type;
  final String productPhoto;
  final int stock;
  final int? quantity;

  ShoppingCart({
    required this.cartId,
    required this.productName,
    required this.price,
    required this.productId,
    required this.type,
    required this.productPhoto,
    required this.stock,
    required this.quantity,
  });

  factory ShoppingCart.fromJson({required Map<String, dynamic>? map}) {

    return ShoppingCart(
      cartId: map?['cartId'],
      productName: map?['productName'],
      price: map?['price'],
      type: map?['type'],
      productPhoto: map?['productPhoto'],
      stock: map?['stock'],
      quantity: map?['quantity'],
      productId: map?['productId'],
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'cartId': cartId,
      'productName': productName,
      'price': price,
      'type': type,
      'productPhoto': productPhoto,
      'stock': stock,
      'quantity': quantity,
      'productId': productId,
    };
  }
}
