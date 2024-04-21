class Branch {
  String txtCode;
  String txtName;
  double ils;
  double dollar;

  Branch({
    required this.txtCode,
    required this.txtName,
    required this.ils,
    required this.dollar,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      txtCode: json['txtCode'] ?? '',
      txtName: json['txtName'] ?? '',
      ils: json['ils'] ?? 0.0,
      dollar: json['dollar'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txtCode'] = this.txtCode;
    data['txtName'] = this.txtName;
    data['ils'] = this.ils;
    data['dollar'] = this.dollar;
    return data;
  }
}
