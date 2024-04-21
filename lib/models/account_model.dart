class AccountModel {
  String txtCode;
  String? txtArabicname;
  String txtEnglishname;
  int intLevel;
  int bolIsparent;
  String txtParentcode;
  String txtParentname;
  String txtTreenode;
  int intType;
  int intCategory;
  String txtCurcode;
  double? dblCredit;
  double? dblDebit;
  double dblOpencredit;
  double dblOpendebit;
  double dblMaxdebit;
  double dblMaxcredit;
  double dblBudget;
  String datCreationdate;
  String datOpendate;
  String datClosedate;
  int bolHastransactions;
  int bolActive;
  int? intStatus;
  int bolProject;
  int bolCostcenter;
  int bolDepartment;
  int bolBank;
  String txtNotes;
  String txtRestrictedjcode;
  String? txtRank;
  int bolBalancesheet;
  int bolIncomeandexpenditure;
  int bolProfitandloss;
  String txtClassificationcode;
  int bolCurrvariance;
  int bolRestrictedcurtransaction;

  AccountModel({
    required this.txtCode,
    this.txtArabicname,
    required this.txtEnglishname,
    required this.intLevel,
    required this.bolIsparent,
    required this.txtParentcode,
    required this.txtParentname,
    required this.txtTreenode,
    required this.intType,
    required this.intCategory,
    required this.txtCurcode,
    this.dblCredit,
    this.dblDebit,
    required this.dblOpencredit,
    required this.dblOpendebit,
    required this.dblMaxdebit,
    required this.dblMaxcredit,
    required this.dblBudget,
    required this.datCreationdate,
    required this.datOpendate,
    required this.datClosedate,
    required this.bolHastransactions,
    required this.bolActive,
    this.intStatus,
    required this.bolProject,
    required this.bolCostcenter,
    required this.bolDepartment,
    required this.bolBank,
    required this.txtNotes,
    required this.txtRestrictedjcode,
    this.txtRank,
    required this.bolBalancesheet,
    required this.bolIncomeandexpenditure,
    required this.bolProfitandloss,
    required this.txtClassificationcode,
    required this.bolCurrvariance,
    required this.bolRestrictedcurtransaction,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        txtCode: json['txtCode'] ?? "",
        txtArabicname: json['txtArabicname'] ?? "",
        txtEnglishname: json['txtEnglishname'] ?? "",
        intLevel: json['intLevel'] ?? 0,
        bolIsparent: json['bolIsparent'] ?? 0,
        txtParentcode: json['txtParentcode'] ?? "",
        txtParentname: json['txtParentname'] ?? "",
        txtTreenode: json['txtTreenode'] ?? "",
        intType: json['intType'] ?? 0,
        intCategory: json['intCategory'] ?? 0,
        txtCurcode: json['txtCurcode'] ?? "",
        dblCredit: json['dblCredit'] ?? 0,
        dblDebit: json['dblDebit'] ?? 0,
        dblOpencredit: json['dblOpencredit'] ?? 0,
        dblOpendebit: json['dblOpendebit'] ?? 0,
        dblMaxdebit: json['dblMaxdebit'] ?? 0,
        dblMaxcredit: json['dblMaxcredit'] ?? 0,
        dblBudget: json['dblBudget'] ?? 0,
        datCreationdate: json['datCreationdate'] ?? "",
        datOpendate: json['datOpendate'] ?? "",
        datClosedate: json['datClosedate'] ?? "",
        bolHastransactions: json['bolHastransactions'] ?? 0,
        bolActive: json['bolActive'] ?? 0,
        intStatus: json['intStatus'] ?? 0,
        bolProject: json['bolProject'] ?? 0,
        bolCostcenter: json['bolCostcenter'] ?? 0,
        bolDepartment: json['bolDepartment'] ?? 0,
        bolBank: json['bolBank'] ?? 0,
        txtNotes: json['txtNotes'] ?? "",
        txtRestrictedjcode: json['txtRestrictedjcode'] ?? "",
        txtRank: json['txtRank'] ?? "",
        bolBalancesheet: json['bolBalancesheet'] ?? 0,
        bolIncomeandexpenditure: json['bolIncomeandexpenditure'] ?? 0,
        bolProfitandloss: json['bolProfitandloss'] ?? 0,
        txtClassificationcode: json['txtClassificationcode'] ?? "",
        bolCurrvariance: json['bolCurrvariance'] ?? 0,
        bolRestrictedcurtransaction: json['bolRestrictedcurtransaction'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'txtCode': txtCode,
        'txtArabicname': txtArabicname,
        'txtEnglishname': txtEnglishname,
        'intLevel': intLevel,
        'bolIsparent': bolIsparent,
        'txtParentcode': txtParentcode,
        'txtParentname': txtParentname,
        'txtTreenode': txtTreenode,
        'intType': intType,
        'intCategory': intCategory,
        'txtCurcode': txtCurcode,
        'dblCredit': dblCredit,
        'dblDebit': dblDebit,
        'dblOpencredit': dblOpencredit,
        'dblOpendebit': dblOpendebit,
        'dblMaxdebit': dblMaxdebit,
        'dblMaxcredit': dblMaxcredit,
        'dblBudget': dblBudget,
        'datCreationdate': datCreationdate,
        'datOpendate': datOpendate,
        'datClosedate': datClosedate,
        'bolHastransactions': bolHastransactions,
        'bolActive': bolActive,
        'intStatus': intStatus,
        'bolProject': bolProject,
        'bolCostcenter': bolCostcenter,
        'bolDepartment': bolDepartment,
        'bolBank': bolBank,
        'txtNotes': txtNotes,
        'txtRestrictedjcode': txtRestrictedjcode,
        'txtRank': txtRank,
        'bolBalancesheet': bolBalancesheet,
        'bolIncomeandexpenditure': bolIncomeandexpenditure,
        'bolProfitandloss': bolProfitandloss,
        'txtClassificationcode': txtClassificationcode,
        'bolCurrvariance': bolCurrvariance,
        'bolRestrictedcurtransaction': bolRestrictedcurtransaction,
      };
}
