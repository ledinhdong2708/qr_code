import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: bgColor,
        padding: AppStyles.paddingContainer,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: const AssetImage(
        //     'assets/loginbackground.jpg',
        //   ),
        //   fit: BoxFit.cover,
        //   colorFilter: ColorFilter.mode(
        //     Colors.white.withOpacity(0.2),
        //     BlendMode.dstATop,
        //   ),
        // )),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/loginbackground.jpg',
                width: double.infinity,
                height: height / 2,
              ),
              textFormFieldMethod("User ID", const Icon(Icons.person)),
              textFormFieldMethod("Password", const Icon(Icons.lock)),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                horizontal: 100,
                vertical: 12,
              ),
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
