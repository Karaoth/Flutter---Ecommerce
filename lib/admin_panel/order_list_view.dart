import 'package:ecommerce_demo_project/services/date_calculator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/costumer_order.dart';
import '../models/products.dart';
import '../models/shopping_cart.dart';
import '../view_model/costumer_order_view_model.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({Key? key}) : super(key: key);

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  List<CostumerOrder>? costumerOrderList;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          StreamBuilder<List<CostumerOrder>>(
            stream: Provider.of<CostumerOrderViewModel>(context)
                .getOrderListFromApi(),
            builder: (context, asyncSnapshot) {
              if (!(asyncSnapshot.hasData)) {
                return const Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                return const Center(child: Text('Bir Hata Meydana Geldi'));
              } else {
                costumerOrderList = asyncSnapshot.data;

                return Flexible(
                  child: ListView.builder(
                    itemCount: costumerOrderList?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.orange),
                        ),
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                'Costumer E-mail: ${costumerOrderList?[index].costumerEmail}'),
                            const SizedBox(height: 10),
                            Text(
                                'Costumer Id: ${costumerOrderList?[index].costumerId}'),
                            const SizedBox(height: 10),
                            Text(
                                'Costumer name: ${costumerOrderList?[index].costumerDisplayName}'),
                            const SizedBox(height: 10),
                            Text(
                              'Order Date: ${DateCalculator.
                              datetimeToString(DateCalculator()
                                  .fromTimestampToDateTime(costumerOrderList![index].orderDate))}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                                'Total Sum: ${costumerOrderList?[index].totalSum}'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                              orderListDetails:
                                                  costumerOrderList![index]
                                                      .cartList),
                                        ));
                                  });
                                },
                                child: const Text('Order Detail'))
                          ],
                        ),
                      );
                    },
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

class OrderDetails extends StatefulWidget {
  final List<ShoppingCart>? orderListDetails;

  const OrderDetails({Key? key, required this.orderListDetails})
      : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

/// burada Slidable paketini kullanmayı dene!!..
class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: widget.orderListDetails!.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: Image(
                              image: NetworkImage(
                                  '${widget.orderListDetails![index].productPhoto}'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              'Product Id: ${widget.orderListDetails![index].productId}'),
                          const SizedBox(height: 10),
                          Text(
                              'Product Name: ${widget.orderListDetails![index].productName}'),
                          const SizedBox(height: 10),
                          Text(
                              'Product Price: ${widget.orderListDetails![index].price}'),
                          const SizedBox(height: 10),
                          Text(
                              'Product Type: ${widget.orderListDetails![index].type}'),
                          const Divider(color: Colors.orange, thickness: 2),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
