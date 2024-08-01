import 'package:flutter/material.dart';

class ListItems extends StatefulWidget {
  final List<dynamic> listItems;
  final void Function(int index) onTapItem;
  final void Function(int index)? onDeleteItem;
  final bool enableDismiss;
  final List<Map<String, String>> labelsAndChildren;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final bool enableSearch; // New parameter for search functionality
  final bool enableExpansion; // New parameter for optional Expansion

  const ListItems({
    super.key,
    required this.listItems,
    required this.onTapItem,
    this.onDeleteItem,
    this.enableDismiss = false,
    required this.labelsAndChildren,
    this.isLoading = false,
    this.onLoadMore,
    this.enableSearch = false, // Default to false
    this.enableExpansion = false, // Default to false
  });

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List<dynamic> _filteredItems = [];
  String _searchQuery = '';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.listItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredItems = widget.listItems;
      } else {
        _filteredItems = widget.listItems.where((item) {
          for (var labelAndChild in widget.labelsAndChildren) {
            final child = labelAndChild['child']!;
            final value = item[child]?.toString().toLowerCase() ?? '';
            if (value.contains(_searchQuery.toLowerCase())) {
              return true;
            }
          }
          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredItems.length + (widget.onLoadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredItems.length) {
          return widget.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TextButton(
                  onPressed: widget.onLoadMore,
                  child: const Text('Load More'),
                );
        }

        var item = _filteredItems[index];
        Widget listItem = GestureDetector(
          onTap: () => widget.onTapItem(index),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.labelsAndChildren.map((labelAndChild) {
                final label = labelAndChild['label']!;
                final child = labelAndChild['child']!;
                return Text('$label: ${item[child]}');
              }).toList(),
            ),
          ),
        );

        if (widget.enableDismiss) {
          return Dismissible(
            key: Key(item.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              if (widget.onDeleteItem != null) {
                widget.onDeleteItem!(index);
              }
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: listItem,
          );
        } else {
          return listItem;
        }
      },
    );

    return Column(
      children: [
        if (widget.enableSearch) // Conditionally show search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterItems,
            ),
          ),
        widget.enableExpansion ? Expanded(child: listView) : listView,
      ],
    );
  }
}
