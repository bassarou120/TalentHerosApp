import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:talentherosapp/base/custom_loader.dart';
import 'package:talentherosapp/models/signup_body_model.dart';
import 'package:talentherosapp/routes/route_helper.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/utils/colors.dart';
import 'package:talentherosapp/utils/dimensions.dart';
import 'package:talentherosapp/widgets/app_text_field.dart';
import 'package:talentherosapp/widgets/big_text.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      "t.png",
      "f.png",
      "g.png",
    ];
    void _registration(AuthController authController){

      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(name.isEmpty){
        showCustomSnackBar("Type in your name", title: "Name");

      }else if(phone.isEmpty){
        showCustomSnackBar("Type in your phone number", title: "Phone number");

      }else if(email.isEmpty){
        showCustomSnackBar("Type in your email address", title: "Email address");

      }else if(!GetUtils.isEmail(email)){
        showCustomSnackBar("Type in a valid email address", title: "Valid email address");

      }else if(password.isEmpty){
        showCustomSnackBar("Type in your password", title: "password");

      }else if(password.length<6){
        showCustomSnackBar("Password cannot be less than six characters", title: "Password");

      }else{

        SignUpBody signUpBody = SignUpBody(
            name: name,
            phone: phone,
            email: email,
            password: password);
        authController.registration(signUpBody).then((status){
          if(status.isSuccess){
          print("Success registration");
          Get.offNamed(RouteHelper.getInitial());
          }else{
           showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,

        body: GetBuilder<AuthController>(builder: (_authController){
          return !_authController.isLoading?SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Dimensions.screenHeight*0.05,),
                //app logo
                Container(
                  height: Dimensions.screenHeight*0.25,
                  child: Center(
                    child:
                    Image.asset("assets/image/logo_th_1.jpg", width: Dimensions.splashImg,),

                    // CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   radius: 80,
                    //   backgroundImage: AssetImage(
                    //       "assets/image/logo_th_1.jpg"
                    //   ),
                    // ),
                  ),
                ),

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
                ),

                AppTextField(textController: nameController,
                    hintText: "Nom",
                    icon: Icons.person),
                SizedBox(height: Dimensions.height20,),
                AppTextField(textController: nameController,
                    hintText: "Prénom",
                    icon: Icons.person),
                SizedBox(height: Dimensions.height20,),

                SizedBox(height: Dimensions.height20,),
                //Your email
                AppTextField(textController: emailController,
                    hintText: "Email",
                    icon: Icons.email),
                SizedBox(height: Dimensions.height20,),
                //Your password
                AppTextField(textController: passwordController,
                    hintText: "Password",
                    icon: Icons.password_sharp, isObscure: true,),
                SizedBox(height: Dimensions.height20,),
                //Your name
                AppTextField(textController: nameController,
                    hintText: "Name",
                    icon: Icons.person),
                SizedBox(height: Dimensions.height20,),
                //Your phone
                AppTextField(textController: phoneController,
                    hintText: "Phone",
                    icon: Icons.phone),
                SizedBox(height: Dimensions.height20,),

                //sign up button
                GestureDetector(
                  onTap: (){
                    _registration(_authController);
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
                        text: "Sign Up",
                        size: Dimensions.font20+Dimensions.font20/2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height10,),
                //tag line
                RichText(text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                    text: "Have an account already?",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20
                    )
                )),

                SizedBox(height: Dimensions.screenHeight*0.05,),
                //sign up options
                RichText(text: TextSpan(
                    text: "Sign up using on of the following methods",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font16
                    )
                )),
                Wrap(
                  children: List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: Dimensions.radius30,
                      backgroundImage: AssetImage(
                          "assets/image/"+signUpImages[index]
                      ),
                    ),
                  )),

                )

              ],
            ),
          ):const CustomLoader();
        })
    );


  }
}
