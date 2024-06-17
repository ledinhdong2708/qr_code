import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';

class CustomNotificationDialog extends StatefulWidget {
  final String message;
  final String type; // "success", "error", "info"

  CustomNotificationDialog({required this.message, required this.type});

  @override
  _CustomNotificationDialogState createState() =>
      _CustomNotificationDialogState();
}

class _CustomNotificationDialogState extends State<CustomNotificationDialog> {
  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color backgroundColor;
    Color textColor;

    if (widget.type == "success") {
      icon = Icons.check_circle;
      backgroundColor = successColor;
      textColor = Colors.white;
    } else if (widget.type == "error") {
      icon = Icons.error;
      backgroundColor = errorColor;
      textColor = Colors.white;
    } else {
      icon = Icons.info;
      backgroundColor = warningColor;
      textColor = Colors.white;
    }

    return AlertDialog(
      backgroundColor: backgroundColor,
      content: Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(
          minWidth: 250, // Minimum width
          maxWidth: MediaQuery.of(context).size.width * 0.8, // Maximum width
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              widget.message,
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "OK",
            style: TextStyle(
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Usage in your widget
void exampleUsage(BuildContext context, bool isSuccess) {
  String message =
      isSuccess ? "User updated successfully!" : "Failed to update user.";
  String type = isSuccess ? "success" : "error";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomNotificationDialog(message: message, type: type);
    },
  );
}
