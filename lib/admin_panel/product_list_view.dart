import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../view_model/product_view_model.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text('Ürün Listesi'),
          StreamBuilder<List<Products>>(
            stream: Provider.of<ProductViewModel>(context, listen: false)
                .getProductsList(),
            builder: (context, asyncSnapshot) {
              if (!(asyncSnapshot.hasData)) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (asyncSnapshot.hasError) {
                return const Center(
                  child: Text('BİR HATA MEYDANA GELDİ'),
                );
              } else {
                List<Products>? productList = asyncSnapshot.data;
                print('admin panel product list: ${productList?.length}');
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('uzunluk: ${productList?.length}'),
                          Flexible(
                            child: ListView.builder(
                              itemCount: productList?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                        '${productList?[index].productName}'),
                                    subtitle: Column(
                                      children: [
                                        Text(
                                            'ürün fiyatı: ${productList?[index].price}'),
                                        const SizedBox(height: 5),
                                        Text('id: ${productList?[index].productId}'),
                                      ],
                                    ),
                                    leading: FadeInImage(
                                      height: 100,
                                      width: 100,
                                      alignment: Alignment.center,
                                      placeholder: const AssetImage(""),
                                      image: NetworkImage(
                                          '${productList?[index].productPhoto}'),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 3)),
                                    tileColor: Colors.white12,
                                    trailing: const Text('Stok Bilgisi:'),
                                  ),
                                );
                              },
                            ),
                          )
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
    );
  }
}
