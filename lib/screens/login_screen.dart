import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = "";
  String role = "";
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      message = "";
      role = "";
    });

    try {
      final url = Uri.parse('http://127.0.0.1:5000/auth/login');

      // ✅ SEND email & password to backend
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          message = data['message'];
          role = data['role'] ?? "";
        });

        // 🔥 Debug print
        print("User Role: $role");

      } else {
        setState(() {
          message = "Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        message = "Error: ${e.toString()}";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: const Text("Login"),
                  ),

            const SizedBox(height: 20),

            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),

            // 🔥 Show role (NEW)
            if (role.isNotEmpty)
              Text(
                "Role: $role",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}