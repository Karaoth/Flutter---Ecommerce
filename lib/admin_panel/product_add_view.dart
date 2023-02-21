import 'dart:io';

import 'package:ecommerce_demo_project/view_model/product_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../widgets/buttons_and_textfields.dart';

class ProductAddView extends StatefulWidget {
  const ProductAddView({Key? key}) : super(key: key);

  @override
  State<ProductAddView> createState() => _ProductAddViewState();
}

enum types { phone, game, computer }

class _ProductAddViewState extends State<ProductAddView> {
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _myProductIdController = TextEditingController();
  final TextEditingController _myProductNameController =
      TextEditingController();
  final TextEditingController _myProductPriceController =
      TextEditingController();
  final TextEditingController _myProductStockController =
  TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? image;
  String? type;
  String? photoUrl;

  @override
  void dispose() {
    _myProductNameController.dispose();
    _myProductPriceController.dispose();
    super.dispose();
  }

  Future<void> imagePicker() async {
    final XFile? _pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (_pickedFile != null) {
        image = File(_pickedFile.path);
      }
    });
    if (_pickedFile != null) {
      photoUrl = await uploadImageToFirebaseStroage(image!);
    }
  }

  Future<String> uploadImageToFirebaseStroage(File fileImage) async {
    String path = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    Reference photoReference =
        FirebaseStorage.instance.ref().child('productPhoto').child(path);

    TaskSnapshot taskSnapshot = await photoReference.putFile(fileImage);
    String uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();

    return uploadedImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(width: 5, color: Colors.orange),
          ),
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.90,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Form(
            key: _loginKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: textInputDecoration(
                        labelText: 'ProductName',
                        icon: const Icon(
                            Icons.production_quantity_limits_rounded)),
                    controller: _myProductNameController,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: textInputDecoration(
                        labelText: 'Product Price',
                        icon: const Icon(Icons.price_change_outlined)),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'your password cannot be less than 6 characters';
                      } else {
                        return null;
                      }
                    },
                    controller: _myProductPriceController,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: textInputDecoration(
                        labelText: 'Product Stock',
                        icon: const Icon(Icons.storage)),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'your password cannot be less than 6 characters';
                      } else {
                        return null;
                      }
                    },
                    controller: _myProductStockController,
                  ),
                  const SizedBox(height: 15),
                  DropdownButton<String>(
                    hint: const Text('Click to Choose The Type Of Product',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(5, 5)),
                    icon: const Icon(
                      Icons.select_all_rounded,
                      color: Colors.orange,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'phone', child: Text('phone')),
                      DropdownMenuItem(
                          value: 'computer', child: Text('computer')),
                      DropdownMenuItem(value: 'game', child: Text('game')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                  type != null
                      ? Text(
                          'Selected Type is: $type',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          'Selected Type',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(height: 15),
                  Stack(
                    alignment: Alignment.center,
                    fit: StackFit.loose,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.orange)),
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: image != null
                            ? Image.file(image!)
                            : const Image(
                                image: NetworkImage(
                                    'https://cdn.iconscout.com/icon/free/png-256/flutter-2038877-1720090.png')),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: () async {
                            await imagePicker();
                          },
                          icon: const Icon(Icons.photo_camera_rounded,
                              size: 50, color: Colors.orange),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: ElevatedButton(
                              style: myBuildButtonStyle(),
                              onPressed: () async {
                                int stock = int.parse(_myProductStockController.text);
                                int price =
                                    int.parse(_myProductPriceController.text);
                                String productId =
                                    ' ${DateTime.now().millisecondsSinceEpoch}';
                                String defaultImage =
                                    'https://cdn.iconscout.com/icon/free/png-256/flutter-2038877-1720090.png';

                                Products newProduct = Products(
                                  type: type!,
                                  stock: stock,
                                  productName: _myProductNameController.text,
                                  price: price,
                                  productPhoto: photoUrl ?? defaultImage,
                                  productId: productId,
                                );

                                await Provider.of<ProductViewModel>(context,
                                        listen: false)
                                    .addtoProduct(
                                        map: newProduct.toJson(),
                                        documentPath: productId);
                              },
                              child: const Text('Add The Product')),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: ElevatedButton(
                              style: myBuildButtonStyle(),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
