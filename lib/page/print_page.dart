import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadSavedDevice();
  }

  Future<void> _saveDeviceAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_device_address', address);
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

  Future<void> _loadSavedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('saved_device_address');

    if (savedAddress != null) {
      // Tìm thiết bị có địa chỉ này
      for (BluetoothDevice device in _devices) {
        if (device.address == savedAddress) {
          _connect(device);
          break;
        }
      }
    }
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
      await _saveDeviceAddress(device.address ?? '');
    } else {
      setState(() {
        _status = 'Connection failed';
      });
    }
  }

  Future<void> _removeSavedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_device_address');
  }

  String _removeDiacritics(String str) {
    const withDia =
        'áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ';
    const withoutDia =
        'aaaaaăăăăăâââââdeeeeeeeeeeeiiiiiioooooôôôôôơơơơơuuuuuưưưưưyyyyyAAAAAĂĂĂĂĂÂÂÂÂÂDEEEEEEEEEEEIIIIIIOOOOOÔÔÔÔÔƠƠƠƠƠUUUUƯƯƯƯƯYYYYY';

    for (int i = 0; i < str.length; i++) {
      int index = withDia.indexOf(str[i]);
      if (index != -1) {
        str = str.replaceAll(str[i], withoutDia[index]);
      }
    }
    return str;
  }

  void _print() async {
    if (_selectedDevice != null) {
      Map<String, dynamic> config = {};
      List<LineText> list = [];

      String itemCode = _removeDiacritics(widget.data['itemCode'] ?? '');
      String itemName = _removeDiacritics(widget.data['itemName'] ?? '');
      String whse = _removeDiacritics(widget.data['whse'] ?? '');
      String uoMCode = _removeDiacritics(widget.data['uoMCode'] ?? '');
      String batch = _removeDiacritics(widget.data['batch'] ?? '');
      String slThucTe = _removeDiacritics(widget.data['slThucTe'] ?? '');
      String remake = _removeDiacritics(widget.data['remake'] ?? '');

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Item Code: $itemCode',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Item Name: $itemName',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Warehouse: $whse',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'UoM Code: $uoMCode',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Batch: $batch',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'SL Thuc Te: $slThucTe',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Remake: $remake',
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_QRCODE,
        content: '${widget.data['docEntry']}/${widget.data['lineNum']}/${widget.data['batch']}',
            // 'ID: ${widget.data['id']}, DocEntry: ${widget.data['docEntry']}, LineNum: ${widget.data['lineNum']}',
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
