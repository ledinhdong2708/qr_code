import 'package:flutter/material.dart';
import 'package:qr_code/constants/colors.dart';

class Dropdownbutton extends StatefulWidget {
  final List<String> items;
  final String? hintText;
  final String? labelText;
  final String? databaseText;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;
  Dropdownbutton(
      {
        super.key,
        required this.items,
        required this.hintText,
        required this.labelText,
        this.databaseText,
        this.onSaved,
        this.controller,});

  @override
  State<Dropdownbutton> createState() => _DropdownbuttonState();
}

class _DropdownbuttonState extends State<Dropdownbutton> {
  String? valueChoose;
  @override
  void initState() {
    super.initState();
    // Kiểm tra và đặt giá trị ban đầu cho valueChoose và controller
    if (widget.controller != null && widget.items.contains(widget.controller!.text)) {
      valueChoose = widget.controller!.text;
    } else {
      valueChoose = widget.items.isNotEmpty ? widget.items[0] : null;
      if (widget.controller != null) {
        widget.controller!.text = valueChoose!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90,
          margin: const EdgeInsets.all(10),
          child: Text(
            widget.labelText!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 45,
            margin: const EdgeInsets.all(10),
            color: fieldInput,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: fieldInput,
                contentPadding: EdgeInsets.all(10),
              ),
              hint: Text(
                widget.hintText!,
                style: const TextStyle(
                  color: fieldInputText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              isExpanded: true,
              value: valueChoose,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: fieldInputText,
              ),
              onChanged: (newValue) {
                setState(() {
                  valueChoose = newValue;
                  if (widget.controller != null) {
                    widget.controller!.text = newValue!;
                  }
                });
              },
              onSaved: widget.onSaved,
              items: widget.items.map((String value) {
                String displayValue = value;
                // Check if there's any special condition to modify the item display
                if (widget.databaseText != null &&
                    widget.databaseText == value) {
                  displayValue = widget.databaseText!;
                }
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(displayValue),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
