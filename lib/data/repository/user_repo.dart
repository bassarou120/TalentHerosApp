import 'package:talentherosapp/data/api/api_client.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:get/get.dart';
class UserRepo{
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response>getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }
}