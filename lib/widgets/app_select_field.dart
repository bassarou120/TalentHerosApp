import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:select_form_field/select_form_field.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppSelectField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  List<Map<String, dynamic>> items;
  String dialogTitle;
  String dialogSearchHint;
  bool isObscure;
  bool maxLines;
  AppSelectField({Key? key,

  required this.textController,
  required this.hintText,
  required this.icon,
  required this.items,
  required this.dialogTitle,
  required this.dialogSearchHint,
    this.isObscure=false,
  this.maxLines=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(1, 1),
                  color: Colors.grey.withOpacity(0.2)
              )
            ]
        ),
        child:   SelectFormField(
          type: SelectFormFieldType.dialog,
          controller: textController,
          //initialValue: _initialValue,
          icon: Icon(icon, color: AppColors.yellowColor,),
            // Icon(Icons.format_shapes),
          labelText: hintText,
          changeIcon: false,
          enableSuggestions: true,
          dialogTitle: 'Sélection de pays',
          dialogCancelBtn: 'Annuler',
          enableSearch: true,
          dialogSearchHint: 'Rechercher pays',
          items: items,

          onChanged: (val) => print(val),
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) =>  print(val),
        ),

/*
        TextField(
          maxLines: maxLines?3:1,
          obscureText: isObscure?true:false,
          controller: textController,
          decoration: InputDecoration(
            //hint text
            hintText: hintText,
            //prefixIcon
            prefixIcon: Icon(icon, color: AppColors.yellowColor,),
            // focusedBorder
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.white,
                )
            ),
            // enabledBoarder
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.white,
              ),
            ),
            // border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),

            ),

          ),
        )
        */
    );
  }
}
