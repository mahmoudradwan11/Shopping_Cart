import 'package:cart/controller/cart_provider.dart';
import 'package:cart/modules/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import '../../core/sql_server.dart';
import '../../models/cart_model.dart';
import '../../models/item_model.dart';
import 'cart_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DBHelper dioHelper = DBHelper();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product List'),
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: Item.products.length,
          itemBuilder: (context, index) {
            var product = Item.products[index];
            return Card(
              color: Colors.blueGrey.shade200,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(
                      height: 80,
                      width: 80,
                      image: NetworkImage(product.image),
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Name: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                    text: '${product.name}\n',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Unit: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text: '${product.unit.toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text: '${product.price.toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade900),
                        onPressed: () {
                          final cart =
                          Provider.of<CartProvider>(context, listen: false);
                          dioHelper
                              .insert(
                            Cart(
                              id: index,
                              productId: index.toString(),
                              productName: product.name,
                              initialPrice: product.price,
                              productPrice: product.price,
                              quantity: ValueNotifier(1),
                              unitTag: product.unit,
                              image: product.image,
                            ),
                          )
                              .then((value) {
                            cart.addTotalPrice(product.price.toDouble());
                            cart.addCounter();
                            showSnackBar(
                              context: context,
                              message: 'Added to Cart',
                              color: Colors.green,
                            );
                          }).onError((error, stackTrace) {
                            showSnackBar(
                              context: context,
                              message: 'Product already in cart',
                              color: Colors.red,
                            );
                            print(error.toString());
                          });
                        },
                        child: const Text('Add to Cart')),
                  ],
                ),
              ),
            );
          }),
    );
  }
}