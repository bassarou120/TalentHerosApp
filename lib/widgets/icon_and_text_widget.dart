import 'package:flutter/cupertino.dart';
import 'package:talentherosapp/widgets/small_text.dart';

import '../utils/dimensions.dart';


class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  double size;
  IconAndTextWidget({Key? key,
    required this.icon,
    required this.text,
    this.size=9,

    required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor,size: Dimensions.iconSize24),
        SizedBox(width: 5,),
        SmallText(text: text,size: size,),
      ],
    );
  }
}
