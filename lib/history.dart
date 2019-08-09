import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:coucou/model/record_item.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  List<Object> _items = [];
  var userId = '5d4996ef7018fabeba9c1182';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    Response res;
    Dio dio = new Dio();
    res = await dio.get("http://127.0.0.1:3000/api/record/list?userId=$userId");
    var data = res.data['data'];
    setState(() {
      _items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_items);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的记录')
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemExtent: 106.0,
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: CustomListItem(
                dateTime: '2019-8-7',
                amount: 20,
                thumbnail: Image.network(
                  'https://p0.meituan.net/scarlett/4613a4d17ef91e5977e73f941276c1d021671.png',
                ),
              )
            );
          },
        ),
      )
    );
  }
}


class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.dateTime,
    this.amount,
  });

  final Widget thumbnail;
  final String dateTime;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _RecordDescription(
              dateTime: dateTime,
              amount: amount,
            ),
          ),
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
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '￥$amount',
            style: const TextStyle(fontSize: 20.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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

