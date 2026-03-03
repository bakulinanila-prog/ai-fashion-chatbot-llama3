import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashion_chat_app/services/cart_service.dart';
import 'package:fashion_chat_app/screens/cart_screen.dart';
import 'category_screen.dart';
import 'chat_screen.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  void openCategory(BuildContext context, String gender) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(gender: gender),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "FASHION",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        actions: [

          // Fashion Assistant Icon
          IconButton(
            icon: const Icon(
              Icons.auto_awesome,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatScreen(),
                ),
              );
            },
          ),

          // Cart with badge
          Consumer<CartService>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                    ),
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

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HERO IMAGE
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 420,
                  child: Image.asset(
                    "assets/images/home_banner.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 420,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.25),
                ),
                const Positioned(
                  bottom: 60,
                  left: 24,
                  child: Text(
                    "NEW COLLECTION",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // CENTER FASHION ASSISTANT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "FASHION ASSISTANT",
                    style: TextStyle(
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // CATEGORY BLOCKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [

                  buildCategoryButton(context, "WOMEN"),
                  const SizedBox(height: 16),

                  buildCategoryButton(context, "MEN"),
                  const SizedBox(height: 16),

                  buildCategoryButton(context, "KIDS"),
                ],
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryButton(BuildContext context, String label) {
    return GestureDetector(
      onTap: () => openCategory(
          context, label[0] + label.substring(1).toLowerCase()),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}