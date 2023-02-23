import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../view_model/product_view_model.dart';
import '../widgets/buttons_and_textfields.dart';

class ProductUpdateView extends StatefulWidget {
  const ProductUpdateView({Key? key}) : super(key: key);

  @override
  State<ProductUpdateView> createState() => _ProductUpdateViewState();
}

class _ProductUpdateViewState extends State<ProductUpdateView> {
  TextEditingController _myProudctStockController = TextEditingController();
  TextEditingController _myProductNameController = TextEditingController();
  TextEditingController _myProductPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Products? _updateProduct;

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
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 3)),
                                    tileColor: Colors.white12,
                                    trailing: IconButton(
                                      icon: const Icon(Icons.update,
                                          color: Colors.orange),
                                      onPressed: () {
                                        setState(() {
                                          _updateProduct = productList?[index];
                                          _myProudctStockController.text =
                                              _updateProduct!.stock.toString();
                                          _myProductNameController.text =
                                              _updateProduct!.productName;
                                          _myProductPriceController.text =
                                              _updateProduct!.price.toString();
                                        });
                                      },
                                    ),
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
          const SizedBox(height: 20),
          Flexible(
            child: UpdateProductsForm(
              formKey: _formKey,
              myProudctIdController: _myProudctStockController,
              myProductNameController: _myProductNameController,
              myProductPriceController: _myProductPriceController,
              updateProduct: _updateProduct,
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateProductsForm extends StatefulWidget {
  const UpdateProductsForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController myProudctIdController,
    required TextEditingController myProductNameController,
    required TextEditingController myProductPriceController,
    required Products? updateProduct,
  })  : _formKey = formKey,
        _myProudctStockController = myProudctIdController,
        _myProductNameController = myProductNameController,
        _myProductPriceController = myProductPriceController,
        _updateProduct = updateProduct,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _myProudctStockController;
  final TextEditingController _myProductNameController;
  final TextEditingController _myProductPriceController;
  final Products? _updateProduct;


  @override
  State<UpdateProductsForm> createState() => _UpdateProductsFormState();
}

class _UpdateProductsFormState extends State<UpdateProductsForm> {
  File? image;
  final ImagePicker _picker = ImagePicker();
  String? _photoUrl;

  Future<void> imagePicker() async {
    final XFile? _pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, maxHeight: 200);

    setState(() {
      if (_pickedFile != null) {
        image = File(_pickedFile.path);
      } else {
        print('no image selected');
      }
    });

    if(_pickedFile != null) {
      _photoUrl = await uploadImageToFirebaseStroage(image!);
    }
  }

  Future<String> uploadImageToFirebaseStroage(File imageFile) async {
    ///Storage üzerinde ki dosya adını oluşturuyor.
    String path = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    Reference photosRef =
        FirebaseStorage.instance.ref().child('productPhoto').child(path);

    /// TaskSnapshot fotograf yüklemenin sonucu döndüren bir sınıf
    TaskSnapshot uploadTask = await photosRef.putFile(imageFile);

    /// getDownloadURL ile Buradan yüklenen fotografın url'ine ulaşıyoruz.
    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();
    //print('Uploaded Image is ==> $uploadedImageUrl');

    return uploadedImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width * 0.95,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.orange, width: 5),
      ),
      child: Form(
        key: widget._formKey,
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: image != null
                            ? FileImage(image!) as ImageProvider<Object>
                            : widget._updateProduct?.productPhoto != null
                                ? NetworkImage(
                                    widget._updateProduct!.productPhoto)
                                : const NetworkImage(
                                    'https://cdn.iconscout.com/icon/free/png-256/flutter-2038877-1720090.png'),

                        /*
                        widget._updateProduct?.productPhoto != null ? NetworkImage(widget._updateProduct!.productPhoto)
                            : const NetworkImage('https://cdn.iconscout.com/icon/free/png-256/flutter-2038877-1720090.png'),

                         */
                      )),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 230,
                      child: IconButton(
                        icon: const Icon(Icons.photo_camera_rounded,
                            size: 50, color: Colors.orange),
                        onPressed: () {
                          imagePicker();
                        },
                      ),
                    ),
                    Positioned(
                      top: 30,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.orange,
                            size: 45,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: textInputDecoration(
                          labelText: 'Product Stock',
                          icon: const Icon(Icons.password)),

                      controller: widget._myProudctStockController,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: textInputDecoration(
                          labelText: 'Product Name',
                          icon: const Icon(Icons.production_quantity_limits)),

                      controller: widget._myProductNameController,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: textInputDecoration(
                          labelText: 'Product Price',
                          icon: const Icon(Icons.price_change)),

                      controller: widget._myProductPriceController,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: ElevatedButton(
                        style: myBuildButtonStyle(),
                        child: const Text('Update'),
                        onPressed: () {
                          ///burada string'i int'e dönüştürüyoruz.
                          int price =
                              int.parse(widget._myProductPriceController.text);
                          print('price: $price');
                          if (widget._formKey.currentState!.validate()) {
                            Provider.of<ProductViewModel>(context, listen: false)
                                .updateProduct(
                                    documentId: widget._updateProduct!.productId,
                                    price: price,
                                    productName:
                                        widget._myProductNameController.text,
                                    productId: widget._updateProduct!.productId,
                                    productPhoto:
                                        _photoUrl ?? widget._updateProduct!.productPhoto,
                                    type: widget._updateProduct!.type,
                                    quantity: widget._updateProduct!.stock);

                            setState(() {
                              image = null;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
