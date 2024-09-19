import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:talentherosapp/base/custom_loader.dart';
import 'package:talentherosapp/pages/auth/sign_up_page.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/utils/colors.dart';
import 'package:talentherosapp/utils/dimensions.dart';
import 'package:talentherosapp/widgets/app_text_field.dart';
import 'package:talentherosapp/widgets/app_text_field_phone.dart';
import 'package:talentherosapp/widgets/big_text.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/route_helper.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();
    void _login(AuthController authController){

      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if(phone.isEmpty){
        showCustomSnackBar("Type in your phone number", title: "phone number");

      }else if(password.isEmpty){
        showCustomSnackBar("Type in your password", title: "password");

      }else if(password.length<6){
        showCustomSnackBar("Password cannot be less than six characters", title: "Password");

      }else{


        authController.login(phone, password).then((status){
          if(status.isSuccess){
            Get.toNamed(RouteHelper.getInitial());
          }else{
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,

        body: GetBuilder<AuthController>(builder: (authController){
          return !authController.isLoading? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Dimensions.screenHeight*0.05,),
                //app logo
                Container(
                  height: Dimensions.screenHeight*0.25,
                  child: Center(
                    child: Image.asset("assets/image/logo_th_1.jpg", width: Dimensions.splashImg,),
                    // CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   radius:100,
                    //   backgroundImage: AssetImage(
                    //       "assets/image/logo_th_1.jpg"
                    //   ),
                    // ),
                  ),
                ),
                //welcome
                Container(
                  margin: EdgeInsets.only(left: Dimensions.width20),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.height20,),
                      Text(
                        AppConstants.APP_NAME,
                        style: TextStyle(
                            fontSize: Dimensions.font26 ,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "Connectez-vous à votre compte",
                        style: TextStyle(
                            fontSize: Dimensions.font20,
                            //fontWeight: FontWeight.bold
                            color: Colors.grey[500]
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20,),

                //Your phone
                // AppTextFieldPhone(textController: phoneController,
                //   hintText: "Phone",
                //     icon: Icons.phone),
                AppTextField(textController: phoneController,
                    hintText: "Email",
                    icon: Icons.mail),
                SizedBox(height: Dimensions.height20,),
                //Your password
                AppTextField(textController: passwordController,
                    hintText: "Mot de passe",
                    icon: Icons.password_sharp, isObscure:true),

                SizedBox(height: Dimensions.height20,),
                //tag line
                Row(children: [
                  Expanded(child: Container()),
                  RichText(
                      text: TextSpan(
                          text: ".",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.font20
                          )
                      )),
                  SizedBox(width: Dimensions.width20,)
                ],),

                SizedBox(height: Dimensions.screenHeight*0.05,),
                //Sign in
                GestureDetector(
                  onTap:(){
                    _login(authController);
                  },
                  child: Container(
                    width: Dimensions.screenWidth/2,
                    height: Dimensions.screenHeight/13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: AppColors.mainColor,
                    ),
                    child: Center(
                      child: BigText(
                        text: "Se connecter",
                        size: Dimensions.font20+Dimensions.font20/2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.screenHeight*0.05,),
                //sign up options
                RichText(text: TextSpan(
                    text: "Vous n'avez pas de compte ?",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20
                    ),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage(), transition: Transition.fade),
                          text: " Créer ici",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainBlackColor,
                              fontSize: Dimensions.font20
                          ))
                    ]
                )),


              ],
            ),
          ):CustomLoader();
        })
    );
  }
}
