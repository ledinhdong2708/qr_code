import 'package:flutter/material.dart';
import 'package:qr_code/component/custom_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: GridView.count(
            // mainAxisSpacing: 1,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/home/purchasing");
                },
                child: card("assets/purchasing.png", "Purchasing"),
              ),
              InkWell(
                onTap: () => print("123"),
                child: card("assets/sales.png", "Sales-A/R"),
              ),
              InkWell(
                onTap: () => print("123"),
                child: card("assets/inventory.png", "Inventor"),
              ),
              InkWell(
                onTap: () => print("123"),
                child: card("assets/production.png", "Production"),
              ),
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
