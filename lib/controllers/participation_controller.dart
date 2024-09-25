import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/data/repository/campagne_repo.dart';
import 'package:talentherosapp/data/repository/participation_repo.dart';
import 'package:talentherosapp/models/campagnes_model.dart';
import 'package:talentherosapp/models/participations_model.dart';
import 'package:talentherosapp/utils/colors.dart';
// import '../models/cart_model.dart';
import '../models/products_model.dart';
import '../models/campagnes_model.dart';
// import 'cart_controller.dart';

class ParticipationController extends GetxController{
  

  

  final ParticipationRepo participationRepo;

  ParticipationController({required this.participationRepo});

  List<ParticipationModel> _participationList=[];
  List<ParticipationModel> get participationList =>_participationList;

  List<ParticipationModel> _participationEncousList=[];
  List<ParticipationModel> get participationEncousList =>_participationEncousList;

  List<ParticipationModel> _participationTermineList=[];
  List<ParticipationModel> get participationTermineList =>_participationTermineList;

 List<ParticipationModel> _gagnanteList=[];
  List<ParticipationModel> get gagnanteList =>_gagnanteList;


  // late CartController _cart;
  CampagneModel? campagne;
  bool _isLoaded = false;
  bool get isLoading=>_isLoaded;

  int _quantity=0;
  int get quantity=>_quantity;
  int _inCartItems=0;
  int get inCartItems=>_inCartItems+_quantity;

  Future<void> getParticipationList()async {
    try {
      _isLoaded = true;
      Response response = await participationRepo.getParticipationsList();
      if(response.statusCode==200){
        _participationList=[];
        _participationEncousList=[];
        _participationTermineList=[];
        _gagnanteList=[];


        response.body.forEach((v){


          print(ParticipationModel.fromJson(v).etat);
          if(ParticipationModel.fromJson(v).etat=="EN COURS"){

            _participationEncousList.add(ParticipationModel.fromJson(v));
          }else{
            _participationTermineList .add(ParticipationModel.fromJson(v));
          }

          if(ParticipationModel.fromJson(v).status=="GAGNANTE"){
            _gagnanteList.add(ParticipationModel.fromJson(v));

          }



          // _participationList.add(ParticipationModel.fromJson(v));
        });

        print(_participationEncousList);
        print(_participationTermineList);
         _isLoaded=false;
        update();
      }else{
        _isLoaded=false;
        print( response.bodyString);
      }
    }catch(e){
      _isLoaded=false;
    }
  }






}
