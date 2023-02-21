import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_demo_project/views/sing_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shopping_cart.dart';
import '../services/user_auth.dart';
import '../view_model/costumer_order_view_model.dart';
import '../view_model/shopping_cart_view_model_with_shared_preference.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({Key? key}) : super(key: key);

  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
  List<ShoppingCart>? shoppingCartList;
  List<ShoppingCart>? filteredShoppingCartList;

  double totalSum = 0;
  int simpleIntInput = 1;
  String UserId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Shopping Cart'),
        centerTitle: true,
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<List<ShoppingCart>>(
                future:
                    Provider.of<ShoppingCartViewModelWithSharedPref>(context, listen: false)
                        .loadFromSharedPreference(),
                builder: (context, asyncSnapshot) {
                  shoppingCartList = asyncSnapshot.data;
                  filteredShoppingCartList = shoppingCartList?.where((element) => element.cartId == UserId).toList();
                  print('listenin uzunlugu: ${filteredShoppingCartList?.length}');

                  if (!(asyncSnapshot.hasData)) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (asyncSnapshot.hasError) {
                    return const Text(
                        'BİR HATA MEYDANA GELDİ, LÜTFEN TEKRAR DENEYİN');
                  } else {
                    return filteredShoppingCartList!.isEmpty
                        ? const Text(
                            'Your Cart is Empty',
                            style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent),
                          )
                        : Flexible(
                            child: ListView.builder(
                              itemCount: filteredShoppingCartList?.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  onDismissed: (direction) {
                                    Provider.of<ShoppingCartViewModelWithSharedPref>(context,
                                            listen: false)
                                        .deleteIndexOfSharedPreference(filteredShoppingCartList?[index]);
                                    setState(() {});
                                  },
                                  key: UniqueKey(),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(
                                                '${filteredShoppingCartList?[index].productName}'),
                                            subtitle: Text(
                                                'ürün fiyatı: ${filteredShoppingCartList?[index].price}'),
                                            leading: FadeInImage(
                                              height: 100,
                                              width: 100,
                                              placeholder: const AssetImage(""),
                                              image: NetworkImage(
                                                  '${filteredShoppingCartList?[index].productPhoto}'),
                                            ),

                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                side: const BorderSide(
                                                    color: Colors.orangeAccent,
                                                    width: 3)),
                                            tileColor: Colors.white12,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.orange)),
                                        child: Row(
                                          children: [
                                            IconButton(onPressed: () {
                                             
                                            }, icon: const Icon(Icons.add, color: Colors.orange,)),

                                            const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),

                                            IconButton(onPressed: () {

                                            }, icon: const Icon(Icons.remove, color: Colors.orange,)),
                                          ],
                                        ),
                                      ),


                                      /*Flexible(
                                        flex: 2,
                                        child: ElegantNumberButton(
                                          /// Elegant button'u pub.dev'den aldım: flutter_elegant_number_button 0.0.
                                          color: Colors.orange,
                                          textStyle: const TextStyle(fontSize: 5),
                                          initialValue: simpleIntInput,
                                          minValue: 1,
                                          maxValue: 100,
                                          decimalPlaces: 1,
                                          buttonSizeHeight: 50,
                                          buttonSizeWidth: 28,
                                          step: 1,
                                          onChanged: (value) {
                                            simpleIntInput = value.toInt();
                                          },

                                        )
                                      ),

                                       */
                                    ],
                                  ),


                                );
                              },
                            ),
                          );
                  }
                },
              ),

              /// TOPLAM TUTARI EKRANA YAZDIRAMIYORUM!!!!
              //Text('Toplam Tutar: ${productList!.isNotEmpty ? productList!.map((e) => e.price * e.quantity).reduce((value, element) => value + element).toStringAsFixed(2) : 0}'),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.deepOrange, width: 3)),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(side: BorderSide(width: 100))),
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                  child: const Text('ORDER', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await _showMyTotalSumDialog();
                    await myOrderFunction(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> myOrderFunction(BuildContext context) async {
    if (shoppingCartList != null) {
      for (int i = 0; i < shoppingCartList!.length; i++) {
        totalSum += shoppingCartList![i].price * 1;
      }

      print('time2: ${Timestamp.fromDate(DateTime.now())}');

      await Provider.of<CostumerOrderViewModel>(context, listen: false)
          .addOrder(
        cartList: filteredShoppingCartList,
        costumerEmail: FirebaseAuth.instance.currentUser!.email.toString(),
        costumerId: FirebaseAuth.instance.currentUser!.uid.toString(),
        costumerDisplayName:
            FirebaseAuth.instance.currentUser!.displayName.toString(),
        totalSum: totalSum,
        orderDate: Timestamp.fromDate(DateTime.now()),
      );



      await Provider.of<ShoppingCartViewModelWithSharedPref>(context, listen: false)
          .clearSharedPreference(UserId);
      setState(() {});
    }
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
  }


  Future<void> _showMyTotalSumDialog() async {

    double totalSum = 0;
    totalSum = await Provider.of<ShoppingCartViewModelWithSharedPref>(context, listen: false).getTotalSumOfCart();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SİPARİŞ DETAYI'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Toplam tutar: $totalSum'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
