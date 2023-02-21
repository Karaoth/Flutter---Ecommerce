import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../view_model/product_view_model.dart';

class ProductDeleteView extends StatefulWidget {
  const ProductDeleteView({Key? key}) : super(key: key);

  @override
  State<ProductDeleteView> createState() => _ProductDeleteViewState();
}

class _ProductDeleteViewState extends State<ProductDeleteView> {
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
                                        'ürün adı: ${productList?[index].productName}'),
                                    subtitle: Text(
                                        'ürün fiyatı: ${productList?[index].price}'),
                                    leading: FadeInImage(
                                      height: 100,
                                      width: 100,
                                      placeholder: const AssetImage(""),
                                      image: NetworkImage(
                                          '${productList?[index].productPhoto}'),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        context
                                            .read<ProductViewModel>()
                                            .deleteToProduct(
                                                productList![index]);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 3)),
                                    tileColor: Colors.white12,
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
