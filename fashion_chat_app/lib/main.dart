import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashion_chat_app/services/cart_service.dart';
import 'screens/departments_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DepartmentsScreen(),
    );
  }
}