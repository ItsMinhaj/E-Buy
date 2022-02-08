import 'package:e_commerce/const/app_color.dart';
import 'package:flutter/material.dart';

class LeadingFormIcon extends StatelessWidget {
  const LeadingFormIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.secondaryColor,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
