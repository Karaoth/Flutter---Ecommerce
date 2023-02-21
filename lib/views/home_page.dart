import 'package:ecommerce_demo_project/view_model/product_view_model.dart';
import 'package:ecommerce_demo_project/view_model/shopping_cart_view_model_with_shared_preference.dart';
import 'package:ecommerce_demo_project/views/category_page_views/game_page_view.dart';
import 'package:ecommerce_demo_project/views/category_page_views/laptop_page_view.dart';
import 'package:ecommerce_demo_project/views/shopping_cart._view.dart';
import 'package:ecommerce_demo_project/views/sing_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../admin_panel/admin_view.dart';
import '../models/products.dart';
import '../models/shopping_cart.dart';
import '../services/user_auth.dart';
import 'category_page_views/phone_page_view.dart';

enum pagesStatus { HomePage, LaptopPage, PhonePage, GamePage }

/// Burası ana sayfa olacak
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  pagesStatus activePage = pagesStatus.HomePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.orangeAccent,
        width: MediaQuery.of(context).size.width * 0.38,
        child: ListView(
          children: [
            const Divider(color: Colors.orange, thickness: 3),
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 5,
                  image: NetworkImage(
                      'https://blog.logrocket.com/wp-content/uploads/2022/08/add-listtile-flutter.png'),
                ),
              ),
              child: Text('KATEGORİLER', textAlign: TextAlign.center),
            ),
            const Divider(color: Colors.orange, thickness: 3),
            ListTile(
              style: ListTileStyle.drawer,
              onTap: () {
                setState(() {
                  activePage = pagesStatus.HomePage;
                });

                Navigator.of(context).pop();
              },
              title: const Text('TÜM ÜRÜNLER'),
              trailing: const Icon(Icons.production_quantity_limits),
            ),
            ListTile(
              style: ListTileStyle.drawer,
              onTap: () {
                setState(() {
                  activePage = pagesStatus.PhonePage;
                });
                Navigator.of(context).pop();
              },
              title: const Text('TELEFON'),
              trailing: const Icon(Icons.phone_android),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  activePage = pagesStatus.LaptopPage;
                });
                print('page status: $activePage');

                Navigator.of(context).pop();
              },
              title: const Text('LAPTOP'),
              trailing: const Icon(Icons.laptop),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  activePage = pagesStatus.GamePage;
                });
                Navigator.of(context).pop();
              },
              title: const Text('OYUN'),
              trailing: const Icon(Icons.games_sharp),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const myNavigatorWidget(),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        actions: [
          /// Burada kullanıcı giriş yaptıysa Login butonu yerine onun email adresini yazdırıyor
          (FirebaseAuth.instance.currentUser == null ||
                  FirebaseAuth.instance.currentUser!.isAnonymous)
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SingInPage(),
                        ));
                    setState(() {});
                  },
                  child: Text(
                    'Login',
                    style: buildTextStyle(),
                  ))
              : TextButton(
                  onPressed: () {},
                  child: Text('${FirebaseAuth.instance.currentUser!.email}',
                      style: const TextStyle(color: Colors.white)),
                ),
          IconButton(
            onPressed: () async {
              await Provider.of<UserAuth>(context, listen: false).mySignOut();

              print('user çıkış yaptı');

              setState(() {
                FirebaseAuth.instance.currentUser?.reload();
              });
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: activePage == pagesStatus.HomePage
          ? const ProductHomePageWidget()
          : activePage == pagesStatus.LaptopPage
              ? const LaptopPageView()
              : activePage == pagesStatus.GamePage
                  ? const GamePageView()
                  : const PhonePageView(),
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
  }
}

class ProductHomePageWidget extends StatefulWidget {
  const ProductHomePageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductHomePageWidget> createState() => _ProductHomePageWidgetState();
}

class _ProductHomePageWidgetState extends State<ProductHomePageWidget> {
  bool isFiltered = false;
  List<Products>? filteredList = [];
  List<ShoppingCart> shoppingCartList = [];

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
                          children: [
                            const SizedBox(height: 20),

                            /// Arama yapmak için kullanılacak
                            TextField(
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orangeAccent, width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orangeAccent, width: 2),
                                  ),
                                  prefix: const Icon(Icons.search),
                                  hintText: 'Search: The Item Name',
                                  hintStyle: const TextStyle(
                                      color: Colors.orangeAccent),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          style: BorderStyle.solid)),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      isFiltered = true;
                                      filteredList = productDataList
                                          ?.where((element) => element
                                              .productName
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  } else {
                                    setState(() {
                                      isFiltered = false;
                                    });
                                  }
                                }),
                            const SizedBox(height: 15),
                            Flexible(
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: isFiltered == false
                                    ? productDataList?.length
                                    : filteredList?.length,
                                itemBuilder: (context, index) {
                                  /// return Card yorum satırına aldığım yerde ki kodların
                                  /// yerine deneme amaçlı yazdım.
                                  List<Products>? newList = isFiltered == false
                                      ? productDataList
                                      : filteredList;
                                  return Card(
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: Colors.orange)),
                                    shadowColor: Colors.orangeAccent,
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.tight,
                                          child: Image.network(
                                            "${newList?[index].productPhoto}",
                                            height: 75,
                                            width: 75,
                                          ),

                                        ),
                                        Flexible(
                                          child: Text(
                                              '${newList?[index].productName}'),
                                        ),
                                        const SizedBox(height: 10),
                                        Flexible(
                                          child: Text(
                                              'fiyat: ${newList?[index].price}'),
                                        ),
                                        const SizedBox(height: 10),
                                        Flexible(child: Text('stok: ${newList?[index].stock} adet')),
                                        Flexible(
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.shopping_basket,
                                                color: Colors.orangeAccent),
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
            /*
            ElevatedButton(
                onPressed: () {
                  print(
                      'güncel kullanıcı bilgisi: ${FirebaseAuth.instance.currentUser?.uid}');
                },
                child: const Text('Kullanıcı bilgisini gör')),
             */
          ],
        ),
      ),
    );
  }
}

class myNavigatorWidget extends StatelessWidget {
  const myNavigatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.orange,
      destinations: [
        TextButton(
          child: const Text('Admin Panel',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminView(),
                ));
          },
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShoppingCartView(),
                  ));
            },
            icon: const Icon(Icons.shopping_basket)),
      ],
    );
  }
}
