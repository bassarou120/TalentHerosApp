import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/data/repository/auth_repo.dart';
import 'package:talentherosapp/models/pays_model.dart';
import 'package:talentherosapp/models/signup_body_model.dart';

import '../models/response_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;
   List<Map<String, dynamic>> _itemsPays=[];
    List<Map<String, dynamic>> get itemsPays=> _itemsPays ;


  List<PaysModel> _paysAllList=[];
  List<PaysModel> get paysAllList=>  _paysAllList=[];

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      print("My token is "+ response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> loginPhone(String phone, String password) async {

    _isLoading = true;
    update();
    Response response = await authRepo.loginPhone(phone, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {

      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
  Future<ResponseModel> loginEmail(String email, String password) async {

    _isLoading = true;
    update();
    Response response = await authRepo.loginEmail(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {

      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }



  Future<void> getPays( ) async {
    late ResponseModel responseModel;
    Response response = await authRepo.getPays( );
    // print(response.body);
    response.body.forEach((v) {
      _itemsPays.add(  {
        'value':  PaysModel.fromJson(v).id,
        'label': PaysModel.fromJson(v).nom,
        'icon': Icon(Icons.stop),
      }
      );
      print(PaysModel.fromJson(v).nom);
     // _paysAllList.add( );
    });
    // responseModel = ResponseModel(true, response.body );

    // return responseModel;
  }

  void saveUserNumberAndPassword(String number, String password)  {
   authRepo.saveUserNumberAndPassword(number, password);
  }

  bool userLoggedIn(){
    return authRepo.userLoggedIn();
  }

  bool clearSharedData(){
    return authRepo.clearSharedData();
  }
}