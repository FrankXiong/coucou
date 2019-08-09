import 'package:flutter/material.dart';
import 'package:coucou/resource/api.dart';
import 'package:coucou/util/index.dart';
import 'package:coucou/detail.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  List<Object> _items = [];
  var userId = '5d4996ef7018fabeba9c1182';
  Map<int, Image> thumbnailMap = {
    0: Image.asset('assets/img/icon_down.png'),
    1: Image.asset('assets/img/icon_up.png')
  };

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var api = new Api();
    var res = await api.getRecordList();
    var data = res.data['data'];
    setState(() {
      _items = data;
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('我的记录')),
        body: Container(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemExtent: 106.0,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              Map item = _items[index];
              String dateTime = Utils.parseTimestamp(item['createTime']);
              int status = item['status'];
              Image thumbnail = thumbnailMap[status];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: CustomListItem(
                  thumbnail: thumbnail,
                  dateTime: dateTime,
                  amount: item['amount'],
                  image: item['pic'],
                  status: item['status'],
                )
              );
            },
          ),
        ));
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.dateTime,
    this.amount,
    this.image,
    this.status,
  });

  final Widget thumbnail;
  final String dateTime;
  final String image;
  final int status;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _RecordDescription(
              dateTime: dateTime,
              amount: amount,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DetailPage(image, amount, status);
                    }
                  )
                );
              },
            )
          )
        ],
      ),
    );
  }
}

class _RecordDescription extends StatelessWidget {
  const _RecordDescription({
    Key key,
    this.dateTime,
    this.amount,
  }) : super(key: key);

  final String dateTime;
  final amount;

  @override
  Widget build(BuildContext context) {
    var amountStr = amount == 0 ? '无趣的一天' : '￥$amount';
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$amountStr',
            style: const TextStyle(fontSize: 20.0),
          ),
          Text(
            dateTime,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
