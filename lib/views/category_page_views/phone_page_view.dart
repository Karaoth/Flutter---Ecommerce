import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/products.dart';
import '../../view_model/product_view_model.dart';
import '../../view_model/shopping_cart_view_model_with_shared_preference.dart';

class PhonePageView extends StatefulWidget {
  const PhonePageView({Key? key}) : super(key: key);

  @override
  State<PhonePageView> createState() => _PhonePageViewState();
}

class _PhonePageViewState extends State<PhonePageView> {

  bool isFiltered = false;
  List<Products>? filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('HOME PAGE'),
            const SizedBox(height: 10),
            StreamBuilder<List<Products>>(
              stream: Provider.of<ProductViewModel>(context, listen: false)
                  .getProductsList(),
              builder: (context, asyncSnapshot) {
                List<Products>? productDataList = asyncSnapshot.data;

                List<Products>? phoneList = productDataList
                    ?.where((products) => products.type.contains('phone'))
                    .toList();

                print('laptop liste uzunlugu: ${phoneList?.length}');
                print('product liste uzunlugu: ${productDataList?.length}');

                if (asyncSnapshot.hasError) {
                  print('asyncSnapshot error: ${asyncSnapshot.error}');
                  return const Center(
                    child: Text('Bir Hata Oluştu Lütfen Tekrar Deneyin'),
                  );
                } else if (!asyncSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {

                  return Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            TextField(
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide:  BorderSide(color: Colors.orangeAccent, width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:  BorderSide(color: Colors.orangeAccent, width: 2),
                                  ),
                                  prefix: const Icon(Icons.search),
                                  hintText: 'Search: The Item Name',
                                  hintStyle: const TextStyle(color: Colors.orangeAccent),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(style: BorderStyle.solid)),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      isFiltered = true;
                                      filteredList = productDataList
                                          ?.where((element) => element
                                          .productName.toLowerCase()
                                          .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  } else {
                                    setState(() {
                                      isFiltered = false;
                                    });
                                  }
                                }),

                            Flexible(
                              child: ListView.builder(
                                itemCount: isFiltered == false ? phoneList?.length : filteredList?.length,
                                itemBuilder: (context, index) {
                                  /// return Card yorum satırına aldığım yerde ki kodların
                                  /// yerine deneme amaçlı yazdım.

                                  List<Products>? newList = isFiltered == false ? phoneList : filteredList;
                                  return Card(
                                    shadowColor: Colors.orangeAccent,
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              2,
                                          height: 250,
                                          child: Image.network(
                                            "${newList?[index].productPhoto}",
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                        Text(
                                            'ürün adı: ${newList?[index].productName}'),
                                        const SizedBox(height: 10),
                                        Text(
                                            'ürün fiyatı: ${newList?[index].price}'),
                                        IconButton(
                                          icon: Icon(
                                              size: 40, Icons.shopping_basket, color: Colors.orangeAccent),
                                          onPressed: () async {
                                            /// sepete ekleme burada oluyor

                                            await Provider.of<
                                                ShoppingCartViewModelWithSharedPref>(
                                                context,
                                                listen: false)
                                                .saveAsSharedPreference(
                                                newList![index], FirebaseAuth.instance.currentUser!.uid);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
