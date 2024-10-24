import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Keyword extends StatelessWidget {
  final String keyword;
  VoidCallback? deleteFunction;

  Keyword({
    super.key,
    required this.keyword,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Text(
              keyword,
              style: const TextStyle(color: Colors.white),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FloatingActionButton.small(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onPressed: deleteFunction,
                  child: const Icon(Icons.delete),
                ))
          ])),
    );
  }
}
