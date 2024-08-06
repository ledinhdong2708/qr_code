import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/service/inventory_transfer_service.dart';
import 'dart:convert';

import 'list_items.dart';
import '../service/goods_receipt_inven_service.dart';

class ListWarehouses extends StatefulWidget {
  final void Function(String whsCode) onItemSelected;
  const ListWarehouses({super.key, required this.onItemSelected});

  @override
  _ListWarehousesState createState() => _ListWarehousesState();
}

class _ListWarehousesState extends State<ListWarehouses> {
  // int _currentPage = 1;
  // final int _pageSize = 10;
  bool _isLoading = false;
  final List<dynamic> _warehouses = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    final response = await fetchOwhsData();

    if (response != null && response['data'] != null) {
      setState(() {
        _warehouses.addAll(response['data']);
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
        title: const Text('Warehouses List View'),
      ),
      body: _isLoading && _warehouses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListItems(
        listItems: _warehouses,
        enableSearch: true,
        enableExpansion: true,
        onTapItem: (index) {
          // Handle item tap
          var item = _warehouses[index];
          widget.onItemSelected(item['WhsCode']);
          Navigator.pop(context);
        },
        // isLoading: _isLoading,
        // onLoadMore: _loadMoreItems,
        labelsAndChildren: const [
          {'label': 'WhsCode', 'child': 'WhsCode'},
          {'label': 'WhsName', 'child': 'WhsName'},
          // Add more as needed
        ],
      ),
    );
  }
}