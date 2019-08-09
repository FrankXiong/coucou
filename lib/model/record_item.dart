class Item {
  double amount;
  String dateTime;
  String thumbnail;

  Item(this.amount, this.dateTime, this.thumbnail);

  Item.fromJson(Map jsonMap) {
    amount = jsonMap['amount'];
    dateTime = jsonMap['createTime'];
    thumbnail = jsonMap['pic'];
  }

  Map toJson() => {
    'amount': amount,
    'dateTime': dateTime,
    'thumbnail': thumbnail
  };
}