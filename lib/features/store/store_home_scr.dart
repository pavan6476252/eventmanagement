import 'package:flutter/material.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Store'),
    );
  }
}
