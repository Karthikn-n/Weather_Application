import 'package:flutter/material.dart';


class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.value,
    required this.icon,
    required this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(
        icon,
        size: 32,
        ),
       const SizedBox(height: 8),
        Text(lable),
       const  SizedBox(height: 8),
        Text(
          value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 23
        ),
        )
      ],
    );
  }
}
