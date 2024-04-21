import 'dart:convert';

import 'package:new_table/constent/api_constnet.dart';
import 'package:new_table/models/tree_account.dart';
import 'package:new_table/sarvice/api_service.dart';

class AccountController {
  Future<List<TreeAccount>> getAllAccount() async {
    List<TreeAccount> list = [];
    await ApiService().getRequest(urlServer).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var stock in jsonData) {
          list.add(TreeAccount.fromJson(stock));
        }
      }
    });
    return list;
  }
}
