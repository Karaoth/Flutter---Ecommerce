import 'package:ecommerce_demo_project/services/date_calculator.dart';
import 'package:ecommerce_demo_project/services/user_auth.dart';
import 'package:ecommerce_demo_project/view_model/costumer_view_model.dart';
import 'package:ecommerce_demo_project/view_model/costumer_order_view_model.dart';
import 'package:ecommerce_demo_project/view_model/product_view_model.dart';
import 'package:ecommerce_demo_project/view_model/shopping_cart_view_model_with_shared_preference.dart';
import 'package:ecommerce_demo_project/views/home_page.dart';
import 'package:ecommerce_demo_project/views/shopping_cart._view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAuth>(create: (_) => UserAuth(),),
        ChangeNotifierProvider<ProductViewModel>(create: (_) => ProductViewModel(),),
        ChangeNotifierProvider<CostumerViewModel>(create: (_) => CostumerViewModel(),),
        ChangeNotifierProvider<ShoppingCartViewModelWithSharedPref>(create: (_) => ShoppingCartViewModelWithSharedPref(),),
        ChangeNotifierProvider<CostumerOrderViewModel>(create: (_) => CostumerOrderViewModel(),),
        ChangeNotifierProvider<DateCalculator>(create: (_) => DateCalculator(),),
      ],
      builder: (context, child) =>   const MaterialApp(
        home: HomePage(),
      ),
    );
  }


}
