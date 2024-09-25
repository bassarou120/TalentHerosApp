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
import 'package:toggle_switch/toggle_switch.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/route_helper.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);



  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Index for ToggleSwitch (email/phone)
  int indexMethode = 0;
  
  String selectedPhode="";



  void _login(AuthController authController) {
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(indexMethode==0){

      if (email.isEmpty) {
        showCustomSnackBar("Tapez votre email", title: "Email");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "password");
      } else if (password.length < 6) {
        showCustomSnackBar("Le mot de passe ne peut pas contenir moins de six caractères", title: "Mot de passe");
      } else {
        authController.loginEmail(email, password).then((status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }else{

      if (phone.isEmpty) {
        showCustomSnackBar("Tapez votre téléphone", title: "Téléphone");
      } else if (password.isEmpty) {
        showCustomSnackBar("Tapez votre mot de passe", title: "mot de passe");
      } else if (password.length < 6) {
        showCustomSnackBar("Le mot de passe ne peut pas contenir moins de six caractères", title: "Mot de passe");
      } else {

        print(selectedPhode);
        authController.loginPhone(selectedPhode, password).then((status) {

          if (status.isSuccess) {

            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    Get.find<AuthController>().clearSharedData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading
            ? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight * 0.07),
              // App logo
              Container(
                height: Dimensions.screenHeight * 0.25,
                child: Center(
                  child: Image.asset(
                    "assets/image/logo_th_1.jpg",
                    width: Dimensions.splashImg,
                  ),
                ),
              ),
              // Welcome message
              Container(
                margin: EdgeInsets.only(left: Dimensions.width20),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.height20),
                    Text(
                      AppConstants.APP_NAME,
                      style: TextStyle(
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Connectez-vous à votre compte",
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),

              // Toggle for email or phone
              ToggleSwitch(
                minWidth: 150.0,
                initialLabelIndex: indexMethode,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: ['Email', 'Téléphone'],
                icons: [Icons.mail, Icons.phone],
                activeBgColors: [[Colors.blue], [Colors.pink]],
                onToggle: (index) {
                  setState(() {
                    indexMethode = index!;
                  });
                },
              ),
              SizedBox(height: Dimensions.height20),

              // Display email or phone based on indexMethode

              indexMethode == 0
                  ? AppTextField(
                textController: emailController,
                hintText: "Email",
                icon: Icons.mail,
              )
                  : AppTextFieldPhone(
                textController: phoneController,
                hintText: "Téléphone",
                icon: Icons.phone,
                onChange: (phone){
                  setState(() {
                    // indexMethode = index!;
                    selectedPhode=phone.completeNumber;
                  });

                },
              ),
              SizedBox(height: Dimensions.height20),

              // Password input
              AppTextField(
                textController: passwordController,
                hintText: "Mot de passe",
                icon: Icons.password_sharp,
                isObscure: true,
              ),
              SizedBox(height: Dimensions.height20),

              // Sign in button
              GestureDetector(
                onTap: () {
                  _login(authController);
                },
                child: Container(
                  width: Dimensions.screenWidth / 2,
                  height: Dimensions.screenHeight / 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor,
                  ),
                  child: Center(
                    child: BigText(
                      text: "Se connecter",
                      size: Dimensions.font16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.screenHeight * 0.05),

              // Sign up option
              RichText(
                text: TextSpan(
                  text: "Vous n'avez pas de compte ?",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: Dimensions.font16,
                  ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => SignUpPage(), transition: Transition.fade),
                      text: " Créer ici",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainBlackColor,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            : CustomLoader();
      }),
    );
  }
}
/*
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    int? indexMethode=0;
    void _login(AuthController authController){

      String phone = phoneController.text.trim();
      String email = emailController.text.trim();

      String password = passwordController.text.trim();

      if(email.isEmpty){
        showCustomSnackBar("Tapez votre email", title: "Email");

      }else if(password.isEmpty){
        showCustomSnackBar("Type in your password", title: "password");

      }else if(password.length<6){
        showCustomSnackBar("Le mot de passe ne peut pas contenir moins de six caractères", title: "Mot de passe");

      }else{


        authController.login(email, password).then((status){
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
                            fontWeight: FontWeight.bold,
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

                ToggleSwitch(
             minWidth: 150.0,
                  initialLabelIndex:indexMethode,

                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: ['Email', 'Téléphone'],
                  icons: [Icons.mail, Icons.phone],
                  activeBgColors: [[Colors.blue],[Colors.pink]],
                  onToggle: (index) {
                    print('switched to: $index');
                    indexMethode=index;
                  },
                ),
                SizedBox(height: Dimensions.height20,),
                indexMethode==0 ?     AppTextField(textController: emailController,
                    hintText: "Email",
                    icon: Icons.mail) :AppTextFieldPhone(textController: phoneController, hintText: "Téléphone", icon: Icons.phone),
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
*/