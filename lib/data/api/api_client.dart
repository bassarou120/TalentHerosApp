
import 'dart:convert';

import 'package:get/get.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as Http;



class ApiClient extends GetConnect implements GetxService{
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  late Map<String, String> _mainHeaders;

  ApiClient({ required this.appBaseUrl, required this.sharedPreferences}){
    baseUrl = appBaseUrl;
    token = sharedPreferences.getString(AppConstants.TOKEN)??"";
    timeout = Duration(seconds: 30);
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization' : 'Bearer $token',

    };
  }

  void updateHeader(String token){
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization' : 'Bearer $token',
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try{


      print( headers ?? _mainHeaders);

      Response response = await get(uri, headers:   headers ?? _mainHeaders);
      return response;
    }catch(e){

      print("Echec echec --------"+ e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }



    // print("voici l'urel "+ baseUrl.toString()+uri );

    // try {
    //   // debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
    //   Http.Response _response = await Http.get(
    //     Uri.parse(appBaseUrl.toString()+uri),
    //     headers: headers ?? _mainHeaders,
    //   ).timeout(Duration(seconds: timeoutInSeconds));
    //   return handleResponse(_response, uri);
    // } catch (e) {
    //   return Response(statusCode: 1, statusText: noInternetMessage);
    // }


  }
  Future <Response> postData(String uri, dynamic body) async {
    print(body.toString());
    try{
      Response response = await post(uri, body, headers: _mainHeaders);
      print(response.toString());
      return response;
    }catch(e){
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    }catch(e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body, bodyString: response.body.toString(),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(_response.statusCode != 200 && _response.body != null && _response.body is !String) {
      if(_response.body.toString().startsWith('{errors: [{code:')) {
       // ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
       // _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _errorResponse.errors[0].message);
      }else if(_response.body.toString().startsWith('{message')) {
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['message']);
      }
    }else if(_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    // debugPrint('====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
}