import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashion_chat_app/services/cart_service.dart';
import 'package:fashion_chat_app/screens/cart_screen.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String gender;
  final String categoryId;

  const ProductListScreen({
    super.key,
    required this.gender,
    required this.categoryId,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String searchQuery = '';
  String sortOption = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("PRODUCTS"),
        centerTitle: true,
        actions: [
          Consumer<CartService>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.totalItemsCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.totalItemsCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Product>>(
        future: ProductService.loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No products available"));
          }

          List<Product> products = snapshot.data!
              .where((product) =>
                  product.gender.toLowerCase() ==
                      widget.gender.toLowerCase() &&
                  product.categoryId.toLowerCase() ==
                      widget.categoryId.toLowerCase())
              .toList();

          // SEARCH
          if (searchQuery.isNotEmpty) {
            products = products
                .where((product) =>
                    product.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();
          }

          // SORT
          if (sortOption == 'price_asc') {
            products.sort((a, b) => a.price.compareTo(b.price));
          } else if (sortOption == 'price_desc') {
            products.sort((a, b) => b.price.compareTo(a.price));
          }

          return Column(
            children: [

              // SEARCH
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),

              // SORT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: sortOption,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'none',
                      child: Text('No sorting'),
                    ),
                    DropdownMenuItem(
                      value: 'price_asc',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'price_desc',
                      child: Text('Price: High to Low'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      sortOption = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(12)),
                                          child: Image.asset(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                  Icons
                                                      .image_not_supported,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          '${product.price} Kč',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 6),
                                    ],
                                  ),

                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Consumer<CartService>(
                                      builder: (context, cart, child) {
                                        final existingItem = cart.items
                                            .where((item) =>
                                                item.product.id ==
                                                product.id)
                                            .toList();

                                        return AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          child: existingItem.isEmpty
                                              ? GestureDetector(
                                                  key:
                                                      const ValueKey("add"),
                                                  onTap: () {
                                                    cart.addToCart(
                                                        product);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(6),
                                                    decoration:
                                                        BoxDecoration(
                                                      color:
                                                          Colors.black,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  20),
                                                    ),
                                                    child:
                                                        const Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  key:
                                                      const ValueKey("qty"),
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                              horizontal:
                                                                  8,
                                                              vertical:
                                                                  4),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        Colors.black,
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                20),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize
                                                            .min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          cart.decreaseQuantity(
                                                              existingItem
                                                                  .first);
                                                        },
                                                        child:
                                                            const Icon(
                                                          Icons
                                                              .remove,
                                                          size: 16,
                                                          color:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                        child: Text(
                                                          existingItem
                                                              .first
                                                              .quantity
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          cart.increaseQuantity(
                                                              existingItem
                                                                  .first);
                                                        },
                                                        child:
                                                            const Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color:
                                                              Colors.white,
                                                        ),
                                                      ),
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
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}