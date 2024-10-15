import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/APIService.dart';

class AccountTypesModel {
  final int id;
  final String name;
  final String img;
  final String status;

  AccountTypesModel({required this.id, required this.name, required this.img, required this.status});

  factory AccountTypesModel.fromJson(Map<String, dynamic> json){
    return AccountTypesModel(
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
      'status': status
    };
  }
}

class AccountTypes {
  ApiService apiService = ApiService(serverURL);
  Future<List<AccountTypesModel>> getAccountTypes() async {
    final account_types = await apiService.post("/SRVC/ExpenseController.php", {"act": "getAccountType"});

    List<dynamic> account_json = account_types['data'];
    return account_json.map((json) => AccountTypesModel.fromJson(json)).toList();
  }
}