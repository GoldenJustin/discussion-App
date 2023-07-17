
import 'package:http/http.dart' as http;
import 'dart:convert';
class DiscussionGroup{

  int? id;
  String? groupName;
  String? groupDesc;
  DateTime? createAt;
  String? groupJoinCode;

  DiscussionGroup({
    this.id,
    required this.groupName,
    required this.groupDesc,
    this.createAt,
    this.groupJoinCode
  });

  static List<DiscussionGroup> createdGroups = [
    DiscussionGroup(
        id: 101,
        groupName: 'Data Communication',
        groupDesc: 'groupDesc',
        createAt: DateTime.now(),
        groupJoinCode: '101-MLDA'
    ),

    
  ];

  
  void fetchData() async{
    var url = Uri.parse("https://reqres.in/api/login");

    final response = await http.get(url,
      headers: {
      'UserId': '',
        
      }
    );

    if(response.statusCode == 200 || response.statusCode == 400){
      print(response.statusCode.toString());
    } else{
      throw Exception('Fail to load data');
    }
  }
  




}
