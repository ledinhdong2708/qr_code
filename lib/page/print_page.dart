import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrintPage extends StatefulWidget {
  final Map<String, String> data;

  const PrintPage({super.key, required this.data});

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _scanning = false;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    setState(() {
      _scanning = true;
    });
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));
    bluetoothPrint.scanResults.listen((devices) {
      setState(() {
        _devices = devices;
      });
    });

    bluetoothPrint.isScanning.listen((isScanning) {
      setState(() {
        _scanning = isScanning;
      });
    });
  }

  void _connect(BluetoothDevice device) async {
    setState(() {
      _status = 'Connecting...';
    });
    bool connected = await bluetoothPrint.connect(device);

    if (connected) {
      setState(() {
        _selectedDevice = device;
        _status = 'Connected';
      });
    } else {
      setState(() {
        _status = 'Connection failed';
      });
    }
  }

  void _print() async {
    if (_selectedDevice != null) {
      Map<String, dynamic> config = {};
      List<LineText> list = [];
      String jsonData = jsonEncode(widget.data);

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            utf8.decode(utf8.encode('Item Code: ${widget.data['itemCode']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            utf8.decode(utf8.encode('Item Name: ${widget.data['itemName']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: utf8.decode(utf8.encode('Warehouse: ${widget.data['whse']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            utf8.decode(utf8.encode('UoM Code: ${widget.data['uoMCode']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            utf8.decode(utf8.encode('Doc Entry: ${widget.data['docEntry']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            utf8.decode(utf8.encode('Line Number: ${widget.data['lineNum']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: utf8.decode(utf8.encode('Batch: ${widget.data['batch']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            utf8.decode(utf8.encode('SL Thuc Te: ${widget.data['slThucTe']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: utf8.decode(utf8.encode('Remake: ${widget.data['remake']}')),
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_QRCODE,
        content: 'Item Code: ${widget.data['itemCode']}',
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
        size: 1,
      ));

      await bluetoothPrint.printReceipt(config, list);
    }
  }

  @override
  void dispose() {
    bluetoothPrint.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Print'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _scanning
                ? null
                : () {
                    _startScan();
                  },
            child: Text(_scanning ? 'Scanning...' : 'Start Scan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_devices[index].name ?? 'Unknown'),
                  subtitle: Text(_devices[index].address ?? 'Unknown'),
                  onTap: () {
                    _connect(_devices[index]);
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _selectedDevice == null ? null : _print,
            child: const Text('Print'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Status: $_status'),
          ),
        ],
      ),
    );
  }
}
