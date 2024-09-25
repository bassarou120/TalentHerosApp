
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import '../api/api_client.dart';


class ParticipationRepo   extends GetxService{
  final ApiClient apiClient;
  ParticipationRepo({required this.apiClient});

  Future <Response> getParticipationsList() async{

    return await apiClient.getData(AppConstants.MES_PARTICIPATION_URI );


  }

  Future <Response> getCampagneAllList() async{

    // print(AppConstants.BASE_URL+AppConstants.CAMPAGNE_ENCOURS_URI);

    return await apiClient.getData(AppConstants.CAMPAGNE_ALL_URI );
    // return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);

  }

  // Future <Response> getCampagneById(int id) async{

  //   // print(AppConstants.BASE_URL+AppConstants.CAMPAGNE_ENCOURS_URI);

  //   return await apiClient.getData(AppConstants.CAMPAGNE_BY_ID );
  //   // return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);

  // }

  Future<Response> getCampagneById(int id) async {
  // Remplacer dynamiquement {id} dans l'URL par l'ID de la campagne
  String url = '${AppConstants.CAMPAGNE_BY_ID}/$id';
  return await apiClient.getData(url);
}

}