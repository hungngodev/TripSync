import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class Location extends StatelessWidget{
  final String location;
  Function(BuildContext)? deleteFunction;

  Location({
    super.key,
    required this.location,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context){
    return 
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),

        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text( 
                location,
                style: TextStyle(color: Colors.white),
              )
            ]
          ),
        ),

      ),
    );
  }
}