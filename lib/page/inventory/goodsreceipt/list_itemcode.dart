import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../component/list_items.dart';
import '../../../service/goods_receipt_inven_service.dart';

class ListItemcode extends StatefulWidget {
  final void Function(String itemCode, String itemName) onItemSelected;
  const ListItemcode({super.key, required this.onItemSelected});

  @override
  _ListItemcodeState createState() => _ListItemcodeState();
}

class _ListItemcodeState extends State<ListItemcode> {
  // int _currentPage = 1;
  // final int _pageSize = 10;
  bool _isLoading = false;
  final List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    final response = await fetchOitmData();

    if (response != null && response['data'] != null) {
      setState(() {
        _items.addAll(response['data']);
        //_isLoading = false;
      });
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
      throw Exception('Failed to load items');
    }
  }

  // void _loadMoreItems() {
  //   setState(() {
  //     _currentPage++;
  //   });
  //   _fetchItems();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items List View'),
      ),
      body: _isLoading && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListItems(
        listItems: _items,
        enableSearch: true,
        enableExpansion: true,
        onTapItem: (index) {
          // Handle item tap
          var item = _items[index];
          widget.onItemSelected(item['ItemCode'], item['ItemName']);
          Navigator.pop(context);
        },
        // isLoading: _isLoading,
        // onLoadMore: _loadMoreItems,
        labelsAndChildren: const [
          {'label': 'Item Code', 'child': 'ItemCode'},
          {'label': 'Item Name', 'child': 'ItemName'},
          // Add more as needed
        ],
      ),
    );
  }
}