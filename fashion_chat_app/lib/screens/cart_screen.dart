import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("YOUR BAG"),
        centerTitle: true,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Your bag is empty",
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [

                /// PRODUCT LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [

                            Image.asset(
                              item.product.imageUrl,
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "${item.product.price.toStringAsFixed(0)} Kč",
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [

                                      IconButton(
                                        onPressed: () {
                                          cart.decreaseQuantity(item);
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),

                                      Text(
                                        item.quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          cart.increaseQuantity(item);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              "${(item.product.price * item.quantity).toStringAsFixed(0)} Kč",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "TOTAL",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${cart.totalPrice.toStringAsFixed(0)} Kč",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Checkout not implemented"),
                              ),
                            );
                          },
                          child: const Text("CHECKOUT"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}