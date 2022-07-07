import 'package:flutter/material.dart';

import '../models/models.dart';

class ProductoCard extends StatelessWidget {
  final Product product;
  const ProductoCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: _cardBorders(),
        margin: const EdgeInsets.only(top: 20, bottom: 40),
        width: double.infinity,
        height: 400,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(pathImage: product.picture),
            _ProductoDetails(
              id: product.id ?? '',
              name: product.name,
            ),
            Positioned(
                top: 0,
                right: 0,
                child: _PriceTag(
                  price: product.price,
                )),
            //TODO: Mostrar de manera condicional
            if(!product.available)
            Positioned(
                top: 0,
                left: 0,
                child: _NoAvailable(
                ))
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _NoAvailable extends StatelessWidget {
  _NoAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(30))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  String? pathImage;
  _BackgroundImage({
    Key? key,
    this.pathImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: (pathImage == null)?const Image(image: AssetImage('assets/no-image.png'),fit: BoxFit.cover,) : FadeInImage(
          fit: BoxFit.cover,
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(pathImage!),
        ),
      ),
    );
  }
}

class _ProductoDetails extends StatelessWidget {
  final String name;
  final String id;
  const _ProductoDetails({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        decoration: _BuildBoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              id,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() {
    return const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), bottomLeft: Radius.circular(25)));
  }
}

class _PriceTag extends StatelessWidget {
  final double price;
  const _PriceTag({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 70,
      width: 120,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(30))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$${price.toString()}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
