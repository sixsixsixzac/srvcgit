import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/APIService.dart';

class MemberTypesModel {
  final int id;
  final String name;
  final String img;
  final String status;

  MemberTypesModel({required this.id, required this.name, required this.img, required this.status});

  factory MemberTypesModel.fromJson(Map<String, dynamic> json){
    return MemberTypesModel(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'img': img,
      'status': status,
    };
  }
}

class MemberTypes {
  ApiService apiService = ApiService(serverURL);
  Future<List<MemberTypesModel>> getMemberTypes() async{
    final member_types = await apiService.post("/SRVC/ExpenseController.php", {"act": "getMemberType"});

    List<dynamic> member_json = member_types['data'];
    return member_json.map((json) => MemberTypesModel.fromJson(json)).toList();
  }
}