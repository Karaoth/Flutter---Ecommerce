import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/costumer.dart';
import '../view_model/costumer_view_model.dart';

class CostumerListView extends StatefulWidget {
  const CostumerListView({Key? key}) : super(key: key);

  @override
  State<CostumerListView> createState() => _CostumerListViewState();
}

class _CostumerListViewState extends State<CostumerListView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          StreamBuilder<List<Costumer>>(
            stream: Provider.of<CostumerViewModel>(context, listen: false)
                .getCostumerList(),
            builder: (context, asyncSnapshot) {

              List<Costumer>? costumerList = asyncSnapshot.data;

              return Flexible(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: costumerList?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.all(10),
                              shape: Border.all(width: 2, color: Colors.orange),

                              child: ListTile(

                                /// listtile içerisinde ki elementlere daha fazla veri yazmak için
                                /// column kullanmayı deneyeceğim
                                title: Text('e-mail: ${costumerList?[index].costumerEmail}'),
                                subtitle: Text('id: ${costumerList?[index].costumerId}'),
                                trailing: Text('display name: ${costumerList?[index].displayName}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
