import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talentherosapp/controllers/campagne_controller.dart';
import 'package:talentherosapp/models/campagnes_model.dart';
import 'package:talentherosapp/models/products_model.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/widgets/big_text.dart';
import 'package:talentherosapp/widgets/icon_and_text_widget.dart';
import 'package:talentherosapp/widgets/small_text.dart';
import '../../controllers/recommended_product_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_column.dart';
// import '/widgets/icon_and_text_widget.dart';

class CampagnePageBody extends StatefulWidget {
  const CampagnePageBody({Key? key}) : super(key: key);

  @override
  State<CampagnePageBody> createState() => _CampagnePageBodyState();
}

class _CampagnePageBodyState extends State<CampagnePageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue=0.0;
  double _scaleFactor=0.8;
  double _height=Dimensions.pageViewContainer;

  @override
  void initState(){
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue=pageController.page!;

      });
    });
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }


  String formatDate(DateTime date) {
    // Formater la date dans le format jj/mm/aaaa
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatDateString(String dateString) {
    // Formater la date dans le format jj/mm/aaaa

    DateFormat format = DateFormat('dd/MM/yyyy');
    return format.parse(dateString).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        //slider section
        GetBuilder<CampagneController>(builder: (campagneEncours){
          return campagneEncours.isLoaded?Container(
            //color: Colors.redAccent,
            height: Dimensions.pageView,

              child: PageView.builder(
                  controller: pageController,
                  itemCount: campagneEncours.campagneEncoursList.length,
                  itemBuilder: (context, position){
                    return _buildPageItem(position, campagneEncours.campagneEncoursList[position]);
                  }),

          ):CircularProgressIndicator(
            color: AppColors.mainColor,
          );
        }),


        //dots
        GetBuilder<CampagneController>(builder: (campagneEncours){
          return DotsIndicator(
            dotsCount: campagneEncours.campagneEncoursList.isEmpty?1:campagneEncours.campagneEncoursList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),

          

        //Popular text
        SizedBox(height: Dimensions.height30,),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Toutes les campagnes",size: 17,),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom: 1),
                child: BigText(text: ".", color: Colors.black26,),
              ),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(text: "plus récente",),
              )

            ],
          ),
        ),


        //toute les campagne
        //list of food and images

          GetBuilder<CampagneController>(builder: (top20capmage){
            return top20capmage.isLoaded?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: top20capmage.campagneAllList.length,
                itemBuilder: (context, index){

                  final campagne = top20capmage.campagneAllList[index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteHelper.getCampagneDescription(campagne.id!));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                      child: Row(
                        children: [
                          //image section
                          Container(
                            width:Dimensions.listViewImgSize,
                            height: Dimensions.listViewImgSize,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                color:Color(0xFF69c5df),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        AppConstants.BASE_URL+AppConstants.UPLOAD_URL+top20capmage.campagneAllList[index].image!
                                    )
                                )
                            ),
                          ),
                          //text container
                          Expanded(
                            child: Container(
                              height: Dimensions.listViewTextContSize+5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.radius20),
                                  bottomRight: Radius.circular(Dimensions.radius20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BigText(text:top20capmage.campagneAllList[index].titre!,size: 17,),
                                    SizedBox(height: Dimensions.height10-5,),
                                    SmallText(text: top20capmage.campagneAllList[index].visibilite!),
                                    SizedBox(height: Dimensions.height10-5,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconAndTextWidget(icon: Icons.circle_sharp,
                                            text: top20capmage.campagneAllList[index].status!,
                                            iconColor: top20capmage.campagneAllList[index].status=="EN COURS" ? AppColors.ColorGreen:AppColors.ColorRead,
                                          size: 8,
                                        ),
                                        // IconAndTextWidget(icon: Icons.location_on,
                                        //     text: "1.7km",
                                        //     iconColor: AppColors.mainColor),
                                        IconAndTextWidget(icon: Icons.access_time_rounded,
                                            size: 8,
                                            text:  top20capmage.campagneAllList[index].date_fin!  ,
                                            iconColor: AppColors.iconColor2),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }):CircularProgressIndicator(
              color: AppColors.mainColor,
            );
          })

      ],
    );
  }


  Widget _buildPageItem(int index, CampagneModel campagneEncours){
    Matrix4 matrix = new Matrix4.identity();
    if(index==_currPageValue.floor()){
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

    }else if(index ==_currPageValue.floor()+1){
      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

    }else if(index ==_currPageValue.floor()-1){
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

    }else{
      var currScale=0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){

              Get.toNamed(RouteHelper.getCampagneDescription(campagneEncours.id!));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: Dimensions.width9, right: Dimensions.width9),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                            AppConstants.BASE_URL+AppConstants.UPLOAD_URL+campagneEncours.image!
                      )
                  )

              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
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
                padding: EdgeInsets.only(top: Dimensions.height15, left: 15, right: 15),
                child: AppColumn(text:campagneEncours.titre!,nbr_particiapant: "0",expire_date:  campagneEncours.date_fin! ,visibilite:campagneEncours.visibilite! ,),
              ),

            ),
          )
        ],
      ),
    );
  }


}
