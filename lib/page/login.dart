import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/constants/urlAPI.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    _resetLogoutStatus();
  }

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
    // print('Request body: ${jsonEncode(<String, String>{
    //       'username': username,
    //       'password': password,
    //     })}');
    try {
      final uri = Uri.parse(apilogin);
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
        final data = jsonDecode(response.body);
        // Navigate to the Home page
        final userId = data['userId']; // Lấy ID người dùng từ response
        // Lưu token và ID người dùng vào shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
        //token
        final token = data['token'];
        await prefs.setString('token', token);
        await prefs.setString('login', 'success');
        Navigator.popAndPushNamed(
          context,
          Routes.home,
        );
      } else {
        CustomDialog.showDialog(
            context, 'Sai mật khẩu hoặc tài khoản', 'error');
        _isLoading = true;
      }
    } catch (e) {
      CustomDialog.showDialog(
          context, 'Đã xảy ra lỗi. \n Vui lòng thử lại', 'warning');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetLogoutStatus() async {
    // Reset login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkLogin = prefs.getString('logout');
    if (checkLogin == 'success') {
      CustomDialog.showDialog(context, 'Đăng xuất thành công', 'success');
    }
    // Wait for 1 second
    await Future.delayed(const Duration(seconds: 1));
    await prefs.setString('logout', '');
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _isLoading ? null : const CustomAppBar(),
      body: _isLoading
          ? CustomLoading()
          : Container(
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
                        textFormFieldMethod("User ID", const Icon(Icons.person),
                            _usernameController),
                        textFormFieldMethod("Password", const Icon(Icons.lock),
                            _passwordController,
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
