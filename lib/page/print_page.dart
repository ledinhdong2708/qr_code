import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  final Map<String, String> data;
  const PrintPage(this.data, {super.key});

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";
  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;
      setState(() {
        _devices = val;
      });
      if (_devices.isEmpty) {
        setState(() {
          _devicesMsg = "Không có thiết bị nào";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Máy In'),
        backgroundColor: Colors.redAccent,
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg ?? ''))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: const Icon(Icons.print),
                  title: Text(_devices[i].name ?? ''),
                  subtitle: Text(_devices[i].address ?? ''),
                  onTap: () => _startPrint(_devices[i]),
                );
              },
            ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      try {
        var connectResult = await bluetoothPrint.connect(device);
        if (connectResult) {
          Map<String, dynamic> config = {};
          List<LineText> list = [];

          list.add(
            LineText(
              type: LineText.TYPE_TEXT,
              content: "Grocery App",
              weight: 2,
              width: 2,
              height: 2,
              align: LineText.ALIGN_CENTER,
              linefeed: 1,
            ),
          );

          widget.data.forEach((key, value) {
            list.add(
              LineText(
                type: LineText.TYPE_TEXT,
                content: key,
                weight: 0,
                align: LineText.ALIGN_LEFT,
                linefeed: 1,
              ),
            );

            list.add(
              LineText(
                type: LineText.TYPE_TEXT,
                content: value,
                align: LineText.ALIGN_LEFT,
                linefeed: 1,
              ),
            );
          });

          await bluetoothPrint.printReceipt(config, list);
        } else {
          print("Kết nối thất bại");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Không thể kết nối đến thiết bị")),
          );
        }
      } catch (e) {
        print("Lỗi kết nối đến thiết bị: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối đến thiết bị: $e")),
        );
      }
    }
  }
}
