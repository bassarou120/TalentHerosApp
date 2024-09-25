import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/controllers/auth_controller.dart';
import 'package:talentherosapp/routes/route_helper.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/widgets/big_text.dart';
import 'package:talentherosapp/widgets/small_text.dart';
import '../../controllers/campagne_controller.dart';
import '../../controllers/recommended_product_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '/widgets/big_text.dart';
import '/widgets/small_text.dart';
import 'campagne_page_body.dart';

class MainCampagnePage extends StatefulWidget {
  const MainCampagnePage({Key? key}) : super(key: key);

  @override
  State<MainCampagnePage> createState() => _MainCampagnePageState();
}

class _MainCampagnePageState extends State<MainCampagnePage> {
  Future<void> _loadResources() async {
    await Get.find<CampagneController>().getCampagneEncoursList();
    await Get.find<CampagneController>().getCampagneAllList();
    // await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  Widget build(BuildContext context) {

    // bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    // if(_userLoggedIn){
    //   // Get.find<UserController>().getUserInfo();
    //   Get.offNamed(RouteHelper.getSignInPage());
    // }

    return RefreshIndicator(
        child:Column(
      children: [
        //Showing the header
        Container(
          child: Container(
            margin: EdgeInsets.only(top:Dimensions.height45, bottom: Dimensions.height15),
            padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(text:AppConstants.APP_NAME, color:AppColors.mainColor),
                    // Row(
                    //   children: [
                    //     SmallText(text: "Ja ela", color: Colors.black54,),
                    //     Icon(Icons.arrow_drop_down_rounded)
                    //
                    //   ],
                    // )

                  ],
                ),
                Center(
                  child: Container(
                    width: Dimensions.height45,
                    height: Dimensions.height45,
                    child: Icon(Icons.notifications, color: Colors.white, size: Dimensions.iconSize24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      color: AppColors.mainColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        //Showing the body
        Expanded(child: SingleChildScrollView(
          child: CampagnePageBody(),
        )),
      ],
    ),
        onRefresh: _loadResources);
  }
}
