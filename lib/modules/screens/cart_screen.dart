import 'package:badges/badges.dart';
import 'package:cart/controller/cart_provider.dart';
import 'package:cart/core/sql_server.dart';
import 'package:cart/models/cart_model.dart';
import 'package:cart/modules/widgets/plus_minus_buttons.dart';
import 'package:cart/modules/widgets/reusable_widget.dart';
import 'package:cart/modules/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Shopping Cart'),
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
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.cart.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
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
                                  image:
                                  NetworkImage(provider.cart[index].image),
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                                  text:
                                                  '${provider.cart[index].productName}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
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
                                                  text:
                                                  '${provider.cart[index].unitTag}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
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
                                                  text:
                                                  '${provider.cart[index].productPrice}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable:
                                  provider.cart[index].quantity!,
                                  builder: (context, val, child) {
                                    final cart =
                                    Provider.of<CartProvider>(context);
                                    return PlusMinusButtons(
                                      addQuantity: () {
                                        cart.addQuantity(
                                            provider.cart[index].id);
                                        dbHelper!
                                            .updateQuantity(Cart(
                                            id: index,
                                            productId: index.toString(),
                                            productName: provider
                                                .cart[index].productName,
                                            initialPrice: provider
                                                .cart[index].initialPrice,
                                            productPrice: provider
                                                .cart[index].productPrice,
                                            quantity: ValueNotifier(provider
                                                .cart[index]
                                                .quantity!
                                                .value),
                                            unitTag: provider
                                                .cart[index].unitTag,
                                            image:
                                            provider.cart[index].image))
                                            .then((value) {
                                          setState(() {
                                            cart.addTotalPrice(double.parse(
                                                provider
                                                    .cart[index].productPrice
                                                    .toString()));
                                          });
                                        });
                                      },
                                      deleteQuantity: () {
                                        cart.deleteQuantity(
                                            provider.cart[index].id);
                                        cart.removeTotalPrice(double.parse(
                                            provider.cart[index].productPrice
                                                .toString()));
                                      },
                                      text: val.toString(),
                                    );
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    dbHelper!.deleteCartItem(
                                        provider.cart[index].id);
                                    provider
                                        .removeItem(provider.cart[index].id);
                                    provider.removeCounter();
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Colors.red.shade800),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              final ValueNotifier<int?> totalPrice = ValueNotifier(null);
              for (var element in value.cart) {
                totalPrice.value =
                    (element.productPrice * element.quantity!.value) +
                        (totalPrice.value ?? 0);
              }
              return Column(
                children: [
                  ValueListenableBuilder<int?>(
                    valueListenable: totalPrice,
                    builder: (context, val, child) {
                      return ReusableWidget(
                          title: 'Sub-Total',
                          value: r'$' + (val?.toStringAsFixed(2) ?? '0'));
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          showSnackBar(
            color: Colors.green.shade600,
            context: context,
            message: 'Proceed to Pay',
          );
        },
        child: Container(
          color: Colors.yellow.shade600,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Proceed to Pay',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}