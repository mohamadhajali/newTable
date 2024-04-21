import 'package:new_table/models/account_model.dart';
import 'package:new_table/models/branch_model.dart';

class TreeAccount {
  AccountModel? account;
  List<TreeAccount>? children;
  List<Branch>? branches;
  TreeAccount({this.account, this.children, this.branches});

  factory TreeAccount.fromJson(Map<String, dynamic> json) {
    return TreeAccount(
      account: json['account'] != null
          ? AccountModel.fromJson(json['account'])
          : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((i) => TreeAccount.fromJson(i))
              .toList()
          : null,
      branches: json['branches'] != null
          ? (json['branches'] as List).map((i) => Branch.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (account != null) {
      data['account'] = account!.toJson();
    }
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    if (branches != null) {
      data['branches'] = branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
