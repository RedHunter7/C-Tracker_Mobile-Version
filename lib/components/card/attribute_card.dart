import 'package:ctracker/utility/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AttributeCard extends StatelessWidget {
  final String title;
  final String imageIcon;
  final String data;
  final Color iconColor;

  const AttributeCard({
    Key? key,
    required this.title,
    required this.imageIcon,
    this.iconColor = Colors.white,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: secondaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: neutralColor,
              fontFamily: 'OpenSans',
              fontSize: 16,
            ),
          ),
         SvgPicture.asset(
           imageIcon,
           color: iconColor,
         ),
          Text(data,
              style: TextStyle(
                color: neutralColor,
                fontFamily: 'OpenSans',
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}
