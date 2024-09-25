import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talentherosapp/widgets/small_text.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'big_text.dart';
import 'icon_and_text_widget.dart';

class AppColumnParticipation extends StatelessWidget {
  final String text;
  final String expire_date;
  final String nbr_particiapant;
  final String? visibilite;
  const AppColumnParticipation({Key? key, required this.text,required this.nbr_particiapant,required this.expire_date,required this.visibilite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text, size: Dimensions.font12,),
        SizedBox(height: Dimensions.height9,),
        //comments section

        //time and distance

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IconAndTextWidget(icon: Icons.circle_sharp,
            //     text: "Normal",
            //     iconColor: AppColors.iconColor1),
            IconAndTextWidget(icon: Icons.feedback_rounded,
                text: "$visibilite",
                iconColor: AppColors.mainColor,size: 9,),
            IconAndTextWidget(icon: Icons.access_time_rounded,
                text: "publié le $expire_date",
                iconColor: AppColors.iconColor2,size: 9,),
          ],
        )

      ],
    );
  }
}
