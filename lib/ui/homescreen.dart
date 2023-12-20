import 'package:flutter/material.dart';
import 'package:movie_mobile/ui/api_screen.dart';
import 'package:movie_mobile/ui/crud_api_screen.dart';
import 'package:movie_mobile/ui/model_screen.dart';
import 'package:movie_mobile/ui/simple_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isApi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isApi = !isApi;
              });
            },
            icon: Icon(isApi ? Icons.star : Icons.star_border),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Simple CRUD"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SimpleScreen()));
            },
          ),
          ListTile(
            title: const Text("Model CRUD"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ModelScreen()));
            },
          ),
          ListTile(
            title: const Text("API Read"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ApiScreen()));
            },
          ),
          ListTile(
            title: const Text("API CRUD"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CrudApiScreen()));
            },
          ),
        ],
      ),
    );
  }
}
