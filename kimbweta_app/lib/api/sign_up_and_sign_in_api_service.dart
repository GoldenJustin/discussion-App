import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sign_up_model.dart';

class SignupAndSigninAPIService {
  Future<RegisterResponseModel> signUp(RegisterRequestModel requestModel) async {
    var url = Uri.parse("https://postman-echo.com/post");

    final response = await http.post(url, body: requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      print("SUCCESS");
      return RegisterResponseModel.fromJson(
        json.decode(response.body),

      );
    } else {
      print("FAILDED");
      throw Exception('Fail to load data');

    }
  }
}
