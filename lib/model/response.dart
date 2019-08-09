class Res {
  bool success;
  Map data;

  Res(this.success, this.data);

  Res.fromJson(Map<String, dynamic> jsonMap) {
    success = jsonMap['success'];
    data = jsonMap['data'];
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data,
  };
}