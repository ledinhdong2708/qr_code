import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:qr_code/constants/colors.dart';

class CustomDialog {
  static void showDialog(BuildContext context, String message, String type,
      {VoidCallback? onOkPressed}) {
    DialogType dialogType;
    IconData icon;
    Color iconColor;
    switch (type.toLowerCase()) {
      case 'success':
        dialogType = DialogType.success;
        icon = Icons.check_circle;
        iconColor = successColor;
        break;
      case 'error':
        dialogType = DialogType.error;
        icon = Icons.error;
        iconColor = errorColor;
        break;
      case 'info':
        dialogType = DialogType.info;
        icon = Icons.info;
        iconColor = inforColor;
        break;
      default:
        dialogType = DialogType.warning; // Fallback for unknown types
        icon = Icons.warning;
        iconColor = warningColor;
    }

    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.topSlide,
      title: 'Notification',
      desc: message,
      customHeader: Icon(
        icon,
        color: iconColor,
        size: 60,
      ),
      showCloseIcon: true,
      btnOkOnPress: () {
        if (onOkPressed != null) {
          onOkPressed();
        }
      },
    ).show();
  }
}
