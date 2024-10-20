import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/APIService.dart';

class ExpenseTypesModel {
  final int id;
  final String type;
  final String name;
  final String status;
  final String img;
  final String created_at;

  ExpenseTypesModel({required this.id, required this.type, required this.name, required this.status, required this.img, required this.created_at});

  factory ExpenseTypesModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTypesModel(id: json['id'], type: json['type'], name: json['name'], status: json['status'], img: json['img'], created_at: json['created_at']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'name': name, 'status': status, 'img': img, 'created_at': created_at};
  }
}

class ExpenseTypes {
  ApiService apiService = ApiService(serverURL);
  Future<List<ExpenseTypesModel>> getExpenseTypes() async {
    final expense_types = await apiService.post("/SRVC/ExpenseController.php", {"act": "getExpenseTypes"});

    List<dynamic> expense_json = expense_types['data'];
    return expense_json.map((json) => ExpenseTypesModel.fromJson(json)).toList();
  }
}

