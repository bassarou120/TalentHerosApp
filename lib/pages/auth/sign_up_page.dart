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
import 'package:talentherosapp/widgets/app_select_field.dart';
import 'package:talentherosapp/widgets/app_text_field.dart';
import 'package:talentherosapp/widgets/app_text_field_phone.dart';
import 'package:talentherosapp/widgets/big_text.dart';
import 'package:select_form_field/select_form_field.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var nomController = TextEditingController();
    var prenomController = TextEditingController();
    var emailController = TextEditingController();
    var telephoneController = TextEditingController();
    var passwordController = TextEditingController();
    var paysController = TextEditingController();
    var genreController = TextEditingController();

var selectedTelephone="";

    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      "t.png",
      "f.png",
      "g.png",
    ];

    final List<Map<String, dynamic>> _itemsSexe = [
      {
        'value': 'Homme',
        'label': 'Homme',
        'icon': Icon(Icons.man),
      },
      {
        'value': 'Femme',
        'label': 'Femme',
        'icon': Icon(Icons.woman),

      },

    ];

    final AuthController authController= Get.find();
    authController.getPays();
    // print(authController.paysAllList);


    void _registration(AuthController authController){

     String nom = nomController.text.trim();
     String prenom  = prenomController.text.trim();
     String  email  = emailController.text.trim();
     String telephone   = selectedTelephone;
     String password = passwordController.text.trim();
     String pays  = paysController.text.trim();
     String genre  = genreController.text.trim();


      // String name = nameController.text.trim();
      // String phone = phoneController.text.trim();
      // String email = emailController.text.trim();
      // String password = passwordController.text.trim();

      if(nom.isEmpty){
        showCustomSnackBar("Veuillez saisie le nom SVP!", title: "Nom");

      }else if(prenom.isEmpty){
        showCustomSnackBar("Veuillez saisie le prénom SVP!", title: "prénom");
      }else if(email.isEmpty){
        showCustomSnackBar("Veuillez saisie l'email' SVP!", title: "email");
      }else if(!GetUtils.isEmail(email)){
        showCustomSnackBar("Veuillez saisie le email SVP!", title: "email");
      }else if(telephone.isEmpty){
        showCustomSnackBar("Veuillez saisie  le pay SVP!", title: "Pays");
      }else if(password.length<6){
        showCustomSnackBar("Le mot de passe  doit despasser 6 valeur", title: "Nom");
      }else{

        SignUpBody signUpBody = SignUpBody(
            nom: nom  ,
            prenom: prenom  ,
            email:  email  ,
            telephone: telephone  ,
            password: password ,
            pays: pays ,
            genre: genre  );

        print(signUpBody);


        authController.registration(signUpBody).then((status){
          if(status.isSuccess){
          print("Success registration");
          showCustomSnackBar("Inscription réussie",duree: 20);
          Get.offNamed(RouteHelper.getSignInPage());
          }else{
           showCustomSnackBar(status.message,duree: 20);
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

                AppTextField(textController: nomController,
                    hintText: "Nom",
                    icon: Icons.person),
                SizedBox(height: Dimensions.height20,),
                AppTextField(textController: prenomController,
                    hintText: "Prénom",
                    icon: Icons.person),
                SizedBox(height: Dimensions.height20,),

                SizedBox(height: Dimensions.height20,),
                //Your email
                AppTextField(textController: emailController,
                    hintText: "Email",
                    icon: Icons.email),

                SizedBox(height: Dimensions.height20,),

                AppTextFieldPhone(textController: telephoneController,
                    hintText: "Téléphone",
                    icon: Icons.phone,
                onChange: (phone){
                  selectedTelephone=phone.completeNumber;
                },),
                SizedBox(height: Dimensions.height20,),
                //Your password
                AppTextField(textController: passwordController,
                    hintText: "Mot de passe",
                    icon: Icons.password_sharp, isObscure: true,),
                SizedBox(height: Dimensions.height20,),
                //Your name

                AppSelectField(
                  dialogTitle: 'Sélection de pays',
                  dialogSearchHint:'Rechercher pays' ,
                  hintText: "pays",
                  textController:paysController ,
                 icon: Icons.location_on_sharp,
                  items: _authController.itemsPays,

                ),

                SizedBox(height: Dimensions.height20,),
                //Your phone

                AppSelectField(
                  dialogTitle: 'Sélection genre',
                  dialogSearchHint:'Rechercher genre' ,
                  hintText: "Genre",
                  textController:genreController ,
                  icon: Icons.safety_divider,
                  items: _itemsSexe,

                ),

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
                        text: "S'inscrire",
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
                    text: "Vous avez déjà un compte ?",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20
                    )
                )),

                SizedBox(height: Dimensions.screenHeight*0.05,),
                //sign up options
                // RichText(text: TextSpan(
                //     text: "Sign up using on of the following methods",
                //     style: TextStyle(
                //         color: Colors.grey[500],
                //         fontSize: Dimensions.font16
                //     )
                // )),
                // Wrap(
                //   children: List.generate(3, (index) => Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: CircleAvatar(
                //       radius: Dimensions.radius30,
                //       backgroundImage: AssetImage(
                //           "assets/image/"+signUpImages[index]
                //       ),
                //     ),
                //   )),
                //
                // )

              ],
            ),
          ):const CustomLoader();
        })
    );


  }
}
