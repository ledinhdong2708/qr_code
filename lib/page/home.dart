import 'package:flutter/material.dart';
import 'package:qr_code/component/custom_app_bar.dart';
import 'package:qr_code/component/user_detail_button.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/routes/routes.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
