import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talentherosapp/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/controllers/participation_controller.dart';
import 'package:talentherosapp/pages/participation/view_participation_list.dart';
// import 'package:talentherosapp/pages/order/view_order.dart';
import 'package:talentherosapp/utils/colors.dart';

import '../../base/custom_app_bar.dart';
// import '../../controllers/order_controller.dart';
import '../../utils/dimensions.dart';
class ParticipationPage extends  StatefulWidget {
  const ParticipationPage({Key? key}) : super(key: key);

  @override
  State<ParticipationPage> createState() => _ParticipationPageState();
}

class _ParticipationPageState extends State<ParticipationPage> with TickerProviderStateMixin {

  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState(){
    super.initState();
    Get.lazyPut(()=>ParticipationController(participationRepo:Get.find()));
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();

    _tabController = TabController(length: 2, vsync: this);
    if(_isLoggedIn){

      Get.find<ParticipationController>().getParticipationList();
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: "Mes publications"),
      body: _isLoggedIn
          ?
      Column(
        children: [
          Container(
            width: Dimensions.screenWidth,
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              controller: _tabController,
              tabs: const [
                Tab(text: "En cours",),
                Tab(text: "Terminée",)
            ],
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children:const [
                  ViewParticipationList(isCurrent:true),
                  ViewParticipationList(isCurrent:false)
                  // ViewOrder(isCurrent:true),
                  //   ViewOrder(isCurrent: false),
                ]),
          )
        ],
      ) : Center(
        child: Text("Veuillez vous connecter pour voir vos participations."),
      ),
    );
  }
}
