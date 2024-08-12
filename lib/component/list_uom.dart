import 'package:flutter/material.dart';

import 'list_items.dart';
import '../service/goods_receipt_inven_service.dart';

class ListUom extends StatefulWidget {
  final void Function(String uomCode) onItemSelected;
  const ListUom({super.key, required this.onItemSelected});

  @override
  _ListUomState createState() => _ListUomState();
}

class _ListUomState extends State<ListUom> {
  // int _currentPage = 1;
  // final int _pageSize = 10;
  bool _isLoading = false;
  final List<dynamic> _uom = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    final response = await fetchOuomData();

    if (response != null && response['data'] != null) {
      setState(() {
        _uom.addAll(response['data']);
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
        title: const Text('UoM List View'),
      ),
      body: _isLoading && _uom.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListItems(
              listItems: _uom,
              enableSearch: true,
              enableExpansion: true,
              onTapItem: (index) {
                // Handle item tap
                var item = _uom[index];
                widget.onItemSelected(item['UomCode']);
                Navigator.pop(context);
              },
              // isLoading: _isLoading,
              // onLoadMore: _loadMoreItems,
              labelsAndChildren: const [
                {'label': 'UomCode', 'child': 'UomCode'},
                {'label': 'UomName', 'child': 'UomName'},
                // Add more as needed
              ],
            ),
    );
  }
}
