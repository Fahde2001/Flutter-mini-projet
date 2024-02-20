import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../task/task_page.dart';

class FormWidegt extends StatefulWidget {
  const FormWidegt({
    Key? key,
  }) : super(key: key);

  @override
  _FormWidegtState createState() => _FormWidegtState();
}

class _FormWidegtState extends State<FormWidegt> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String accessToken = '';
  String refreshToken = '';

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      // Display error message in dialog for empty email or password
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

    final String apiUrl = 'http://192.168.1.38:3000/api/auth/local/signin';
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
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(color: Colors.black45),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset("assets/icons/email.svg"),
                ),
              ),
            ),
          ),
          const Text(
            "Password",
            style: TextStyle(color: Colors.black45),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset("assets/icons/password.svg"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: ElevatedButton.icon(
              onPressed: () {
                signIn(
                  emailController.text,
                  passwordController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF050505),
                minimumSize: const Size(double.infinity, 56),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              icon: const Icon(CupertinoIcons.arrow_right),
              label: const Text(
                "Sign In",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
