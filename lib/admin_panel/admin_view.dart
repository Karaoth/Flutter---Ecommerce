import 'package:ecommerce_demo_project/admin_panel/product_add_view.dart';
import 'package:ecommerce_demo_project/admin_panel/product_delete_view.dart';
import 'package:ecommerce_demo_project/admin_panel/product_list_view.dart';
import 'package:ecommerce_demo_project/admin_panel/product_update_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../views/home_page.dart';
import 'costumer_list_view.dart';
import 'order_list_view.dart';

/// flutter_admin_scaffold 1.1.2  paketini kullanmayı düşünebilirim!!..
class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String? productPageValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('ADMİN PANEL'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.orangeAccent,
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.orangeAccent)),
        child: ListView(
          shrinkWrap: true,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 5,
                  image: NetworkImage(
                      'https://blog.logrocket.com/wp-content/uploads/2022/08/add-listtile-flutter.png'),
                ),
              ),
              child: Text('Admin Panel', textAlign: TextAlign.center),
            ),
            Card(
              color: Colors.orange,
              semanticContainer: true,
              shape: const StadiumBorder(
                  side: BorderSide(width: 2, color: Colors.orangeAccent)),
              child: ListTile(
                title: const Text('Ürün Bilgileri',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
                subtitle: DropdownButton<String>(
                  dropdownColor: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(30),
                  items: const [
                    DropdownMenuItem(
                        value: 'item1', child: Text('Ürün Listesi')),
                    DropdownMenuItem(
                      value: 'item2',
                      child: Text('Ürün Silme'),
                    ),
                    DropdownMenuItem(
                        value: 'item3', child: Text('Ürün Güncelleme')),
                    DropdownMenuItem(value: 'item4', child: Text('Ürün Ekle')),
                  ],
                  onChanged: (value) {
                    /// burada value bilgisine göre sayfa açılacak.

                    setState(() {
                      productPageValue = value;
                    });

                    switch (value) {
                      case 'item1':
                        print('item1 seçildi');
                        break;
                      case 'item2':
                        print('item2 seçildi');
                        break;
                      case 'item3':
                        print('item3 seçildi');
                        break;
                      case 'item4':
                        print('item4 seçildi');
                        break;
                    }
                  },
                ),
              ),
            ),
            Card(
              color: Colors.orange,
              shape: const StadiumBorder(
                  side: BorderSide(width: 2, color: Colors.orangeAccent)),
              child: ListTile(
                title: const Text('Müsteri Bilgileri',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
                subtitle: DropdownButton<String>(
                    dropdownColor: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(30),
                    items: const [
                      DropdownMenuItem(
                          value: 'costumer1', child: Text('Müsteri Listesi')),
                    ],
                    onChanged: (value) {
                      /// burada value bilgisine göre sayfa açılacak.

                      setState(() {
                        productPageValue = value;
                      });
                    }),
              ),
            ),
            Card(
              color: Colors.orange,
              shape: const StadiumBorder(
                  side: BorderSide(width: 2, color: Colors.orangeAccent)),
              child: ListTile(
                title: const Text('Sipariş Bilgileri',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
                subtitle: DropdownButton<String>(
                    dropdownColor: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(30),
                    items: const [
                      DropdownMenuItem(
                          value: 'order1', child: Text('Sipariş Listesi')),
                    ],
                    onChanged: (value) {
                      /// burada value bilgisine göre sayfa açılacak.

                      setState(() {
                        productPageValue = value;
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
      body: productPageValue == null
          ? const Center(
              child: Text('İŞLEM İÇİN PANELE BAKIN'),
            )
          : productPageValue == 'item1'
              ? const ProductListView()
              : productPageValue == 'item2'
                  ? const ProductDeleteView()
                  : productPageValue == 'item3'
                      ? const ProductUpdateView()
                      : productPageValue == 'item4'
                          ? const ProductAddView()
                          : productPageValue == 'costumer1'
                              ? const CostumerListView()
                              : const OrderListView(),
    );
  }
}
