class Products {
  final String productName;
  final int price;
  final String productId;
  final String type;
  final String productPhoto;
  final int stock;
  /// BURAYA STOK BİLGİSİ DE EKLEMELİYİM

  Products({
    required this.productName,
    required this.price,
    required this.productId,
    required this.type,
    required this.productPhoto,
    required this.stock,
  });

  factory Products.fromJson({required Map<String, dynamic>? map}) {
    return Products(
      price: map?['price'],
      productName: map?['productName'],
      productId: map?['productId'],
      productPhoto: map?['productPhoto'],
      type: map?['type'],
      stock: map?['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'productName': productName,
      'productId': productId,
      'productPhoto': productPhoto,
      'type': type,
      'stock': stock,
    };
  }
}
