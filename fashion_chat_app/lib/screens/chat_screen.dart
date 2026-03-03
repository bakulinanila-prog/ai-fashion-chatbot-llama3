import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [];
  final Map<String, int> quantities = {};

  List<Product> allProducts = [];

  bool isTyping = false;
  bool isLoaded = false;

  String? selectedGender;
  bool waitingForOccasion = false;

  final List<String> initialQuickActions = [
    "Build me an outfit",
    "Women jackets",
    "Men shoes",
    "Kids clothing",
  ];

  final List<String> genderOptions = ["Women", "Men"];
  final List<String> occasionOptions = ["Casual", "Office", "Evening"];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    allProducts = await ProductService.loadProducts();

    messages.add({
      "role": "bot",
      "text": "Hi.\nI'm your AI stylist.",
      "quick": "initial"
    });

    setState(() => isLoaded = true);
  }

  // ===============================
  // BACKEND CALL
  // ===============================
  Future<void> _sendToBackend(String message) async {

    setState(() => isTyping = true);
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": message,
          "session_id": "mobile_user"
        }),
      );

      final data = jsonDecode(response.body);
      final reply = data["reply"];

      final List<dynamic> ids = (reply["products"] as List?) ?? [];

      final List<Product> filtered =
          allProducts.where((p) => ids.contains(p.id)).toList();

      for (var p in filtered) {
        quantities[p.id] = 1;
      }

      setState(() {
        isTyping = false;
        messages.add({
          "role": "bot",
          "text": filtered.isEmpty
              ? "No results found."
              : "Here are your results.",
          "products": filtered,
          "quick": "initial"
        });
      });

      _scrollToBottom();

    } catch (_) {
      setState(() {
        isTyping = false;
        messages.add({
          "role": "bot",
          "text": "Connection error."
        });
      });
    }
  }

  // ===============================
  // QUICK ACTION HANDLER
  // ===============================
  void _handleQuickAction(String text) {

    if (text == "Build me an outfit") {
      setState(() {
        messages.add({"role": "user", "text": text});
        messages.add({
          "role": "bot",
          "text": "Choose gender:",
          "quick": "gender"
        });
      });
      return;
    }

    if (genderOptions.contains(text)) {
      selectedGender = text.toLowerCase();
      waitingForOccasion = true;

      setState(() {
        messages.add({"role": "user", "text": text});
        messages.add({
          "role": "bot",
          "text": "Choose occasion:",
          "quick": "occasion"
        });
      });
      return;
    }

    if (waitingForOccasion && occasionOptions.contains(text)) {
      waitingForOccasion = false;

      final finalMessage =
          "$selectedGender ${text.toLowerCase()} outfit";

      setState(() {
        messages.add({"role": "user", "text": text});
      });

      _sendToBackend(finalMessage);
      return;
    }

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    _sendToBackend(text);
  }

  // ===============================
  // QUICK BUTTONS
  // ===============================
  Widget _buildQuickButtons(String type) {

    List<String> actions = [];

    if (type == "initial") actions = initialQuickActions;
    if (type == "gender") actions = genderOptions;
    if (type == "occasion") actions = occasionOptions;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((text) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black),
            foregroundColor: Colors.black,
          ),
          onPressed: () => _handleQuickAction(text),
          child: Text(text),
        );
      }).toList(),
    );
  }

  // ===============================
  // PRODUCT CARD (NAVIGATION FIX)
  // ===============================
  Widget _buildProductCard(Product product) {

    final cart = Provider.of<CartService>(context, listen: false);
    final int quantity = quantities[product.id] ?? 1;

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
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 10),
            Text(product.name),
            const SizedBox(height: 4),

            Text(
              "${product.price} Kč",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantities[product.id] =
                                  quantity - 1;
                            });
                          }
                        },
                      ),
                      Text("$quantity"),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () {
                          setState(() {
                            quantities[product.id] =
                                quantity + 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    for (int i = 0; i < quantity; i++) {
                      cart.addToCart(product);
                    }
                  },
                  child: const Text("ADD TO BAG"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildMessage(Map<String, dynamic> message) {

    final isUser = message["role"] == "user";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          Text(message["text"] ?? ""),

          if (message["quick"] != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildQuickButtons(message["quick"]),
            ),

          if (message["products"] != null)
            Column(
              children:
                  (message["products"] as List<Product>)
                      .map((p) => _buildProductCard(p))
                      .toList(),
            ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: LinearProgressIndicator(minHeight: 1.5),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI STYLIST"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount:
                  messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < messages.length) {
                  return buildMessage(messages[index]);
                }
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child:
                      LinearProgressIndicator(minHeight: 1.5),
                );
              },
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Describe what you need...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _controller.clear();
                        _handleQuickAction(value.trim());
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    final text =
                        _controller.text.trim();
                    if (text.isNotEmpty) {
                      _controller.clear();
                      _handleQuickAction(text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}