import 'package:flutter/material.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/page/home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const AssetImage(
            'assets/login_background.png',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.4),
            BlendMode.dstATop,
          ),
        )),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textFormFieldMethod("User ID", const Icon(Icons.person)),
              textFormFieldMethod("Password", const Icon(Icons.lock)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                child: const Text('Login'),
              )
            ],
          )),
        ),
      ),
    );
  }

  TextFormField textFormFieldMethod(String labelText, Icon icon) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        icon: icon,
      ),
    );
  }
}
