import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_code/constants/colors.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Color(0xff616161),
      firstCPColor,
      secondCPColor,
      thirdCPColor,
    ];
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadingAnimationWidget.discreteCircle(
            color: firstCPColor,
            secondRingColor: secondCPColor,
            thirdRingColor: thirdCPColor,
            size: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'FTI SAIGON',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                colors: colorizeColors,
                speed: const Duration(milliseconds: 500),
              ),
            ],
            // totalRepeatCount: 3,
            repeatForever: true,
            pause: const Duration(milliseconds: 200),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          )
        ],
      ),
    );
  }
}
