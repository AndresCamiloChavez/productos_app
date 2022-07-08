import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  static const String productRoute = 'product';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsService>(context).productSelected;
    late ProductFormProvider productFormProvider;
    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(product),
      child: _ProductScreenBody(product: product),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  pathImage: productFormProvider.product.picture,
                ),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 100);
                        if (pickedFile == null) {
                          return;
                        }
                        productService
                            .updateSelectedProductImage(pickedFile.path);
                        print('path image ${pickedFile.path}');
                      },
                    )),
              ],
            ),
            _ProductForm(
              product: productFormProvider.product,
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            if (productFormProvider.isValidForm()) {
              final String? imageUrl = await productService.uploadImage();

              if (imageUrl != null) product.picture = imageUrl;
              await productService.saveOrCreateProduct(product);
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("Sending Message"),
              // ));
            }
          }),
    );
  }
}

class _ProductForm extends StatelessWidget {
  final Product product;
  const _ProductForm({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _BuildDecorationForm(),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: productFormProvider.form,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: product.name,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => product.name = value,
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Nombre del producto', labelText: 'Nombre'),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      product.price = 0;
                    } else {
                      product.price = double.parse(value);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                  initialValue: product.price.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: '\$99.99', labelText: 'Precio'),
                ),
                const SizedBox(height: 30),
                SwitchListTile.adaptive(
                  value: product.available,
                  onChanged: (value) {
                    productFormProvider.isAvailable = value;
                  },
                  title: const Text('Disponible'),
                  activeColor: Colors.indigo,
                ),
                const SizedBox(height: 30),
              ],
            )),
      ),
    );
  }

  BoxDecoration _BuildDecorationForm() {
    return const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5)
        ]);
  }
}
