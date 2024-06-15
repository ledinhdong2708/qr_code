import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });
    print('Request body: ${jsonEncode(<String, String>{
          'username': username,
          'password': password,
        })}');
    try {
      const url = 'http://10.0.2.2:1600/api/v1/login';

      final uri = Uri.parse(url);
      final body = jsonEncode(<String, String>{
        'username': username,
        'password': password,
      });
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('dung');
        final data = jsonDecode(response.body);
        // final token = data['token'];
        // print('Token: $token');
        // // Save token securely
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', token);
        // print('Token saved');
        // Navigate to the Home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        _showErrorDialog("Invalid username or password");
      }
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Failed"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/loginbackground.jpg',
                    width: double.infinity,
                    height: height / 2,
                  ),
                  textFormFieldMethod(
                      "User ID", const Icon(Icons.person), _usernameController),
                  textFormFieldMethod(
                      "Password", const Icon(Icons.lock), _passwordController,
                      isPassword: true),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _login();
                      }
                    },
                    horizontal: 100,
                    vertical: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textFormFieldMethod(
      String labelText, Icon icon, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: icon,
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
