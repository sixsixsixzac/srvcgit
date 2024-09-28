class ExpenseData {
  final int id;
  final int typeId;
  final int forId;
  final int accountType;
  final int amount;
  final DateTime date;
  final DateTime time;
  final int createBy;
  final String typeName;
  final String typeImg;
  final String forWho;
  final String accountTypeName;

  ExpenseData({
    required this.id,
    required this.typeId,
    required this.forId,
    required this.accountType,
    required this.amount,
    required this.date,
    required this.time,
    required this.createBy,
    required this.typeName,
    required this.typeImg,
    required this.forWho,
    required this.accountTypeName,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      id: json['id'],
      typeId: json['type_id'],
      forId: json['for_id'],
      accountType: json['account_type'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      createBy: json['create_by'],
      typeName: json['type_name'],
      typeImg: json['type_img'],
      forWho: json['for_who'],
      accountTypeName: json['account_type_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_id': typeId,
      'for_id': forId,
      'account_type': accountType,
      'amount': amount,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'create_by': createBy,
      'type_name': typeName,
      'type_img': typeImg,
      'for_who': forWho,
      'account_type_name': accountTypeName,
    };
  }
}

class ExpenseResponse {
  final String date;
  final int total;
  final List<ExpenseData> data;

  ExpenseResponse({
    required this.date,
    required this.total,
    required this.data,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<ExpenseData> expenseDataList = dataList.map((item) => ExpenseData.fromJson(item)).toList();

    return ExpenseResponse(
      date: json['date'],
      total: json['total'],
      data: expenseDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total': total,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
