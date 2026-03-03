import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'product_service.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItemsCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  CartService() {
    loadCart();
  }

  void addToCart(Product product) {
    final existing = _items
        .where((item) => item.product.id == product.id)
        .toList();

    if (existing.isEmpty) {
      _items.add(CartItem(product: product, quantity: 1));
    } else {
      existing.first.quantity++;
    }

    saveCart();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    saveCart();
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    item.quantity--;
    if (item.quantity <= 0) {
      _items.remove(item);
    }
    saveCart();
    notifyListeners();
  }

  void removeCompletely(CartItem item) {
    _items.remove(item);
    saveCart();
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _items.map((item) => {
      "id": item.product.id,
      "quantity": item.quantity
    }).toList();

    await prefs.setString("cart", jsonEncode(data));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("cart");

    if (saved == null) return;

    final decoded = jsonDecode(saved) as List;

    final allProducts = await ProductService.loadProducts();

    for (var item in decoded) {
      try {
        final product = allProducts
            .firstWhere((p) => p.id == item["id"]);

        _items.add(CartItem(
          product: product,
          quantity: item["quantity"],
        ));
      } catch (_) {
        
      }
    }

    notifyListeners();
  }
}