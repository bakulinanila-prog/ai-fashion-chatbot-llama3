import 'package:flutter/material.dart';
import 'package:fashion_chat_app/models/product.dart';
import 'package:fashion_chat_app/services/product_service.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedGender = 'Women';

  Widget genderButton(String gender) {
    final isSelected =
        selectedGender.toLowerCase() == gender.toLowerCase();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.black : Colors.grey[300],
        foregroundColor:
            isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Text(gender),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fashion Store")),
      body: FutureBuilder<List<Product>>(
        future: ProductService.loadProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final allProducts = snapshot.data!;

          
          final filteredProducts = allProducts
              .where((product) =>
                  product.gender.toLowerCase() ==
                  selectedGender.toLowerCase())
              .toList();

          if (filteredProducts.isEmpty) {
            return const Center(
                child: Text("No products found"));
          }

          return Column(
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  genderButton("Women"),
                  genderButton("Men"),
                  genderButton("Kids"),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product =
                        filteredProducts[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(
                                    product: product),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius
                                        .vertical(
                                  top: Radius.circular(
                                      12),
                                ),
                                child: Image.asset(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width:
                                      double.infinity,
                                  errorBuilder:
                                      (context,
                                          error,
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
                              padding:
                                  const EdgeInsets
                                      .all(8.0),
                              child: Text(
                                product.name,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                          horizontal:
                                              8),
                              child: Text(
                                "${product.price} Kč",
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .grey,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 8),
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