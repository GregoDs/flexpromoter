import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Homepage!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle navigation or action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Explore more features!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Explore"),
            ),
          ],
        ),
      ),
    );
  }
}
