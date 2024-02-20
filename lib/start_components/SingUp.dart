import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../task/task_page.dart';

class SignUpBottomSheet extends StatefulWidget {
  @override
  _SignUpBottomSheetState createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet>
    with WidgetsBindingObserver {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String confirmPasswordError = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final isKeyboardVisible =
        WidgetsBinding.instance?.window.viewInsets.bottom != 0;
    if (isKeyboardVisible) {
      // Keyboard is visible, you can update your UI here if needed
    } else {
      // Keyboard is hidden, you can update your UI here if needed
    }
  }

  String accessToken = '';
  String refreshToken = '';
  //call API
  Future<void> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content: Text('Email and password are required.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final String apiUrl = 'http://192.168.1.38:3000/api/auth/local/signup';
    Map<String, dynamic> data = {
      'email': email,
      'hash': password,
    };
    try {
      String jsonData = jsonEncode(data);
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Sign-up successful');
          print(response.body);
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', jsonResponse['access_token']);
          prefs.setString('refreshToken', jsonResponse['refresh_token']);
          setState(() {
            accessToken = jsonResponse['access_token'];
            refreshToken = jsonResponse['refresh_token'];
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TaskPage(), // Replace YourHomePage with the actual home page widget
            ),
          );
        } else {
          print('Sign-up failed with status code ${response.statusCode}');
          print(response.body);

          // Display error message in dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sign Up Failed'),
                content: Text('Error: ${response.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle null response
        print('Null response during sign-up');
      }
    } catch (error) {
      print('Error during sign-up: $error');

      // Display specific error message in dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred during sign-up: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: ListView(
        dragStartBehavior: DragStartBehavior.start,
        children: [
          Container(
            height: 600, // Adjust the height here
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Hello! Welcome to TaskFlow. Let's get started.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.email),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.lock),
                      ),
                      errorText: confirmPasswordError.isNotEmpty
                          ? confirmPasswordError
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        setState(() {
                          confirmPasswordError = 'Passwords do not match';
                        });
                      } else {
                        confirmPasswordError = '';
                        signUp(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_right),
                    label: const Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
