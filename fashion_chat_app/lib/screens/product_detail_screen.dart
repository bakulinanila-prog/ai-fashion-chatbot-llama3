import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashion_chat_app/models/product.dart';
import 'package:fashion_chat_app/services/cart_service.dart';
import 'package:fashion_chat_app/screens/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PRODUCT",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Stack(
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
              if (cart.items.isNotEmpty)
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
                      cart.items.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            SizedBox(
              width: double.infinity,
              height: 450,
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${product.price.toStringAsFixed(0)} Kč",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Divider(),
                  const SizedBox(height: 24),

                  const Text(
                    "DESCRIPTION",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    _generateDescription(product),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 34),
                  const Divider(),
                  const SizedBox(height: 24),

                  const Text(
                    "DETAILS",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "• Premium quality fabric\n"
                    "• Minimalist modern cut\n"
                    "• Designed for everyday comfort\n"
                    "• Durable stitching\n"
                    "• Machine washable\n"
                    "• Imported",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 42),

                  // ADD TO BAG BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        cart.addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to cart"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text(
                        "ADD TO BAG",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _generateDescription(Product product) {
    if (product.categoryId.contains("jackets")) {
      return "A refined outerwear essential crafted for cold-season elegance. "
          "This piece combines structured tailoring with functional warmth, "
          "offering a clean silhouette ideal for modern urban styling.";
    }

    if (product.categoryId.contains("tshirts")) {
      return "An elevated wardrobe staple made from soft, breathable cotton. "
          "Designed with a clean minimalist aesthetic, perfect for effortless everyday wear.";
    }

    if (product.categoryId.contains("jeans")) {
      return "Contemporary denim with a structured yet comfortable fit. "
          "A versatile silhouette designed to complement both casual and refined looks.";
    }

    if (product.categoryId.contains("dresses")) {
      return "A modern silhouette designed to enhance natural movement. "
          "Elegant in its simplicity, perfect for both day and evening wear.";
    }

    return "A thoughtfully designed garment blending timeless design with modern comfort. "
        "A versatile piece for a curated wardrobe.";
  }
}