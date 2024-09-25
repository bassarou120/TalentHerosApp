import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talentherosapp/base/custom_loader.dart';
import 'package:talentherosapp/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/controllers/participation_controller.dart';
import 'package:talentherosapp/models/participations_model.dart';
import 'package:talentherosapp/pages/participation/view_participation_list.dart';
import 'package:talentherosapp/routes/route_helper.dart';
import 'package:talentherosapp/utils/app_constants.dart';
// import 'package:talentherosapp/pages/order/view_order.dart';
import 'package:talentherosapp/utils/colors.dart';
import 'package:talentherosapp/widgets/app_column_participation.dart';

import '../../base/custom_app_bar.dart';
// import '../../controllers/order_controller.dart';
import '../../utils/dimensions.dart';
class GuagnantsPage extends  StatefulWidget {
  const GuagnantsPage({Key? key}) : super(key: key);

  @override
  State<GuagnantsPage> createState() => _GuagnantsPageState();
}

class _GuagnantsPageState extends State<GuagnantsPage> with TickerProviderStateMixin {

  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState(){
    super.initState();
    Get.lazyPut(()=>ParticipationController(participationRepo:Get.find()));
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();

    // _tabController = TabController(length: 2, vsync: this);
    if(_isLoggedIn){

      Get.find<ParticipationController>().getParticipationList();
    }

  }
  String formatDate(DateTime date) {
    // Formater la date dans le format jj/mm/aaaa
    return DateFormat('dd/MM/yyyy').format(date);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: "Les  Guagnantes"),
      body: _isLoggedIn
          ?
          GetBuilder<ParticipationController>(builder: (participController){

            if(participController.isLoading==false){
              late List<ParticipationModel> participationList=participController.gagnanteList;


            return   Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10/2, vertical: Dimensions.height10/2),
                  child:ListView.builder(
                      itemCount: participationList.length,
                      itemBuilder: (context, index){
                        return
                          Column(
                            children: [
                              InkWell(
                                  onTap: () {

                                    Get.toNamed(RouteHelper.getCampagneDescription(participationList[index].id));
                                    // Get.snackbar('haut', 'Participation envoyée avec succès.',snackPosition:SnackPosition.TOP,duration: Duration(seconds: 15));

                                  },
                                  child: Center(
                                    child: Stack(

                                      children: [

                                        GestureDetector(
                                          onTap: (){
                                            Get.toNamed(RouteHelper.getParticipationDetail(participationList[index].id),
                                                arguments:participationList[index] );
                                            // Get.snackbar('bas', 'Participation envoyée avec succès.',snackPosition:SnackPosition.TOP,duration: Duration(seconds: 15));
                                            // Get.toNamed(RouteHelper.getCampagneDescription(campagneEncours.id!));
                                          },
                                          child: Container(
                                            height: Dimensions.pageViewContainer*1.2,
                                            margin: EdgeInsets.only(left: Dimensions.width9, right: Dimensions.width9,top: Dimensions.height45),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
                                                image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image:
                                                    NetworkImage(
                                                        AppConstants.BASE_URL+AppConstants.UPLOAD_URL+participationList[index].campagne_image!
                                                    )
                                                )

                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: Dimensions.pageViewTextContainer/1.6,
                                            margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.height20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xFFe8e8e8),
                                                      blurRadius: 3.0,
                                                      offset: Offset(0, 5)
                                                  ),
                                                  BoxShadow(
                                                      color: Colors.white,
                                                      offset: Offset(-5, 0)
                                                  ),
                                                  BoxShadow(
                                                      color: Colors.white,
                                                      offset: Offset(5, 0)
                                                  )
                                                ]
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.only(top: Dimensions.height10, left: 15, right: 15),
                                              child: AppColumnParticipation(
                                                text:participationList[index].campagneTitre,
                                                nbr_particiapant: "0",
                                                expire_date: formatDate (participationList[index].createdAt) ,
                                                visibilite:participationList[index].status  ,),
                                            ),

                                          ),
                                        ),


                                      ],
                                    ),
                                  )

                                /*
                          Column(
                            children: [
                              Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(participationList[index].campagneTitre,),
                                          SizedBox(width: Dimensions.width10/2,),
                                          Text('#${participationList[index].id.toString()}')
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.circular(Dimensions.radius20/4)
                                            ),
                                              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10, vertical: Dimensions.width10/2),
                                              child: Text('${participationList[index].status}',
                                                 style: TextStyle(
                                                    color: Theme.of(context).cardColor,
                                                 ),
                                              ),


                                          ),
                                          SizedBox(height: Dimensions.height10/2),
                                          InkWell(
                                            onTap: ()=>null,
                                            child: Container(
                                             padding: EdgeInsets.symmetric(horizontal: Dimensions.width10, vertical: Dimensions.width10/2),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                                                border: Border.all(width: 1, color: Theme.of(context).primaryColor)
                                              ),
                                              child: Row(
                                                children: [
                                                  Image.asset("assets/image/tracking.png", height: 15, width: 15,color: Theme.of(context).primaryColor,),
                                                  SizedBox(width: Dimensions.width10/2,),
                                                  Text(
                                                      "track order",)

                                                ],
                                              )
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              )
                            ],
                          ),
                          */
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 70,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimensions.height15,)
                            ],
                          );
                      }),
                );


            }else{
            return CustomLoader();
            }
          })
     : Center(
        child: Text("Veuillez vous connecter pour voir vos participations."),
      ),
    );
  }
}
