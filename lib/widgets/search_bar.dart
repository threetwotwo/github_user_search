import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function(String) onTextChange;
  final VoidCallback onCancel;

  final TextEditingController controller;
  final bool showCancelButton;

  SearchBar({
    this.onTextChange,
    this.onCancel,
    this.controller,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
//        height: 45,
//        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        margin: EdgeInsets.all(8),
        child: TextField(
            autofocus: true,
            controller: controller,
            onChanged: onTextChange,
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
//                  size: 18,
                ),
                suffixIcon: showCancelButton
                    ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 16,
                        ),
                        onPressed: onCancel,
                      )
                    : null,
                hintText: 'Search',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero)));
  }
}
