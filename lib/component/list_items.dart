import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  final List<dynamic> listItems;
  final void Function(int index) onTapItem;
  final String labelName1;
  final String labelName2;
  final String labelName3;
  final String labelName4;
  final String listChild1;
  final String listChild2;
  final String listChild3;
  final String listChild4;

  const ListItems({
    super.key,
    required this.listItems,
    required this.onTapItem,
    required this.labelName1,
    required this.labelName2,
    required this.labelName3,
    required this.labelName4,
    required this.listChild1,
    required this.listChild2,
    required this.listChild3,
    required this.listChild4,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        var item = listItems[index];
        return GestureDetector(
          onTap: () => onTapItem(index),
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
              children: [
                Text('$labelName1: ${item[listChild1]}'),
                Text('$labelName2: ${item[listChild2]}'),
                Text('$labelName3: ${item[listChild3]}'),
                Text('$labelName4: ${item[listChild4]}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
