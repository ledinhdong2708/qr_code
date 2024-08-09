import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/constants/colors.dart'; // Import intl package

class DateInput extends StatefulWidget {
  final String labelText;
  final String postDay;
  final TextEditingController? controller;

  const DateInput({
    super.key,
    this.labelText = 'Posting Date:',
    this.postDay = "",
    this.controller,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    if (widget.postDay.isNotEmpty) {
      _internalController.text = widget.postDay;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _internalController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 90,
              margin: const EdgeInsets.all(10),
              child: Text(widget.labelText,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: Container(
              height: 45,
              margin: const EdgeInsets.all(10),
              child: TextField(
                  controller: _internalController,
                  enabled: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "dd/MM/yyyy",
                      fillColor: fieldInput,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ))),
            ),
          ),
        ],
      );
}
