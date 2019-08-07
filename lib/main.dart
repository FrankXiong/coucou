import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coucou/history.dart';

void main() {
  runApp(MyApp());
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String todayTxt = _getToday();
  final _formKey = GlobalKey<FormState>();
  var _image;
  DatabaseReference _recordRef;

  void _goToHistory() {
    Navigator.pushNamed(context, "history");
  }

  static String _getToday() {
    const weekMap = {
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
    String weekday = now.weekday.toString();
    return '$year/$month/$day  $weekMap[$weekday]';
  }

  /*相册*/
  Future _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
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
                    "前往美团外卖App",
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
            _recordDialog()
          ],
        );
      }
    );
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

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
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
                const ListTile(
                  title: Text('2019/7/31'),
                ),
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


  Widget _recordDialog() {
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
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: _openGallery,
                ),
                Container(
                  width: 100,
                  height: 150,
                  child: Image(image: AssetImage('assets/img/tea.png'),),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        // Process data.
                        Navigator.pop(context, true);
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