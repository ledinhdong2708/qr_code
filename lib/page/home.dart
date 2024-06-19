import 'package:flutter/material.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/user_detail_button.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _resetLoginStatus();
  }

  Future<void> _resetLoginStatus() async {
    // Reset login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkLogin = prefs.getString('login');
    if (checkLogin == 'success') {
      CustomDialog.showDialog(context, 'Đăng nhập thành công', 'success');
    }
    // Wait for 1 second
    await Future.delayed(const Duration(seconds: 1));
    await prefs.setString('login', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  // mainAxisSpacing: 1,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.purchasing);
                      },
                      child: card("assets/purchasing.png", "Purchasing"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.sales);
                      },
                      child: card("assets/sales.png", "Sales-A/R"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.inventory);
                      },
                      child: card("assets/inventory.png", "Inventory"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.production);
                      },
                      child: card("assets/production.png", "Production"),
                    ),
                  ],
                ),
              ),
              const UserDetailButton()
            ],
          ),
        ));
  }

  Column card(String imgName, String nameOfCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imgName,
          width: 100,
        ),
        Text(nameOfCard)
      ],
    );
  }
}
