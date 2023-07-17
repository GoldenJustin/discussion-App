class RegisterResponseModel{

  final String? userName;
  final String? email;
  final String? password;

  RegisterResponseModel({this.userName, this.email, this.password});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json){
    return RegisterResponseModel(
        userName: json["UserId"],
        email: json["email"],
        password: json["password"],

    );
  }

}

class RegisterRequestModel{
String? userName;
String? email;
String? password;


RegisterRequestModel({this.userName, this.email, this.password});

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'userName': userName!.trim(),
      'email': email!.trim(),
      'password': password!.trim()
    };

    return map;
  }
}