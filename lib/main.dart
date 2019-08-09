import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coucou/history.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

void saveRecord(int status, [ double amount = 0.0 ]) async {
  var userId = '5d4996ef7018fabeba9c1182';
  Response res;
  Dio dio = new Dio();
  res = await dio.post("http://127.0.0.1:3000/api/record",
    data: {
      "amount": amount,
      "userId": userId,
      "status": status,
    },
    options: new Options(
      contentType: ContentType.parse("application/x-www-form-urlencoded")
    ),
  );
  // Scaffold.of(context).showSnackBar(_saveSuccessSnackBar);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '凑凑',
      theme: ThemeData(
        primaryColor: Colors.black
      ),
      home: MyHomePage(title: '凑凑'),
      //注册路由表
      routes:{
        "history": (context) => HistoryPage(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  String _getToday() {
    Map<int, String> weekMap = {
      1: '星期一',
      2: '星期二',
      3: '星期三',
      4: '星期四',
      5: '星期五',
      6: '星期六',
      7: '星期日',
    };
    DateTime now = new DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString();
    String day = now.day.toString();
    String weekday = weekMap[now.weekday];
    return '$year-$month-$day $weekday';
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(_getToday());
}

class _MyHomePageState extends State<MyHomePage> {
  // final _saveSuccessSnackBar = new SnackBar(content: new Text('真棒!'));
  final String _todayTxt;

  _MyHomePageState(this._todayTxt);

  void _goToHistory() {
    Navigator.pushNamed(context, "history");
  }

  void _openWaimaiApp() async {
    const url = 'https://h5.waimai.meituan.com';
    if (await canLaunch(url)) {
      await launch(url);
      Navigator.pop(context, true);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void showNoDrinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('需要为你下单吗？'),
          children: <Widget>[
            SimpleDialogOption(
                child: RaisedButton(
                  child: Text(
                    "前往美团外卖",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.lightBlue,
                  onPressed: _openWaimaiApp,
                )
              ),
          ],
        );
      }
    );
  }

  void showRecordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('账单记录'),
          children: <Widget>[
            RecordDialog(),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _goToHistory,
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          height: 800,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$_todayTxt'),
                Container(
                  height: 463,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 40),
                            child: Text(
                              '今天喝凑凑了吗',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              showRecordDialog(context);
                            },
                            color: Colors.lightBlue,
                            child: const Text(
                              '喝了',
                              style: TextStyle(fontSize: 16, color: Colors.white)
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              saveRecord(0);
                              showNoDrinkDialog(context);
                            },
                            color: Colors.red,
                            child: const Text(
                              '没喝',
                              style: TextStyle(fontSize: 16, color: Colors.white)
                            ),
                          ),
                        ],
                      ),
                  ),
                )
              ],
            )
          )
        )
      )
    );
  }
}


class RecordDialog extends StatefulWidget {
  @override
  RecordDialogState createState() => RecordDialogState();
}

class RecordDialogState extends State<RecordDialog> {
  final _formKey = GlobalKey<FormState>();
  double _amount;
  var _image;
  bool _isShowPreviewImage = false;
  String _imgUrl = 'http://p0.meituan.net/scarlett/4613a4d17ef91e5977e73f941276c1d021671.png';

  /*相册*/
  Future _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _isShowPreviewImage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '金额',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '不能为空';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入数字';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _amount = double.parse(val);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: _openGallery,
                ),
                PreviewImage(_isShowPreviewImage, _imgUrl),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      var _form = _formKey.currentState;
                      if (_form.validate()) {
                        _form.save();
                        Navigator.pop(context, true);
                        saveRecord(1, _amount);
                      }
                    },
                    child: Text(
                      '保存',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}

class PreviewImage extends StatelessWidget {
  final bool show;
  final String imgUrl;

  PreviewImage(this.show, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    var content;
    if (show) {
      content = Container(
        width: 120,
        height: 120,
        child: Image.network(imgUrl),
      );
    } else {
      content = new Container(height:0.0, width:0.0);
    }
    return content;
  }
}