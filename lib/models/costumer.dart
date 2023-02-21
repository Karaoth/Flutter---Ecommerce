import 'package:ecommerce_demo_project/models/products.dart';

class Costumer {
  final String costumerEmail;
  final String costumerId;
  final String? displayName;
  final String adress;

  Costumer({
    required this.costumerEmail,
    required this.costumerId,
    required this.adress,
    required this.displayName,
  });

  /// Costumer içerisinde firebase cloud'da ayrı bir array içinde bir product nesnesi oluşturulacak

  factory Costumer.fromJson({required Map<String, dynamic>? map}) {
    return Costumer(
      costumerEmail: map?['costumerEmail'],
      costumerId: map?['costumerId'],
      adress: map?['adress'],
      displayName: map?['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'costumerEmail': costumerEmail,
      'costumerId': costumerId,
      'adress': adress,
      'displayName': displayName,
    };
  }
}
