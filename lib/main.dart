import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coucou/history.dart';
import 'package:coucou/resource/api.dart';
import 'package:coucou/util/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '凑凑',
      theme: ThemeData(primaryColor: Colors.black),
      home: MyHomePage(title: '凑凑'),
      //注册路由表
      routes: {
        "history": (context) => HistoryPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  String _getToday() {
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    return Utils.parseTimestamp(timestamp, true);
  }

  @override
  MyHomePageState createState() => MyHomePageState(_getToday());
}

class MyHomePageState extends State<MyHomePage> {
  // final _saveSuccessSnackBar = new SnackBar(content: new Text('真棒!'));
  final String _todayTxt;
  int _status;
  MyHomePageState(this._todayTxt);

  void _goToHistory() {
    Navigator.pushNamed(context, "history");
  }

  void _getTodayStatus() async {
    var res = await new Api().getTodayRecord();
    var data = res['data'];
    var status = -1;
    if (data != null) {
      status = data['status'];
    }
    setState(() {
      _status = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTodayStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _goToHistory,
          )
        ]),
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
                                '今天喝奶茶了吗',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            ButtonGroup(_status)
                          ],
                        ),
                      ),
                    )
                  ],
                )))));
  }
}

class ButtonGroup extends StatelessWidget {
  final status;
  ButtonGroup(this.status);

  void _openWaimaiApp(BuildContext context) async {
    const url = 'https://h5.waimai.meituan.com';
    if (await canLaunch(url)) {
      await launch(url);
      Navigator.pop(context, true);
    } else {
      print('Could not launch $url');
    }
  }

  void _showRecordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('账单记录'),
            children: <Widget>[
              RecordDialog(),
            ],
          );
        });
  }

  void _showNoDrinkDialog(BuildContext context) {
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
                onPressed: () {
                  _openWaimaiApp(context);
                },
              )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var btnDrank = RaisedButton(
      onPressed: () {
        _showRecordDialog(context);
      },
      color: Colors.lightBlue,
      child:
          const Text('喝了', style: TextStyle(fontSize: 16, color: Colors.white)),
    );
    var btnNoDrink = RaisedButton(
      onPressed: () {
        saveRecord(0);
        _showNoDrinkDialog(context);
      },
      color: Colors.red,
      child:
          const Text('没喝', style: TextStyle(fontSize: 16, color: Colors.white)),
    );
    if (status == 1) {
      return btnDrank;
    } else if (status == 0) {
      return btnNoDrink;
    } else {
      return Column(
        children: <Widget>[btnDrank, btnNoDrink],
      );
    }
  }
}

class RecordDialog extends StatefulWidget {
  @override
  RecordDialogState createState() => RecordDialogState();
}

class RecordDialogState extends State<RecordDialog> {
  final _formKey = GlobalKey<FormState>();
  double _amount;
  String _image = 'http://p0.meituan.net/scarlett/4613a4d17ef91e5977e73f941276c1d021671.png';
  bool _isShowPreviewImage = false;

  /* 打开相册 */
  void _openGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    var res = await new Api().uploadImage(image);
    if (res['success']) {
      setState(() {
        _image = res['data'];
        _isShowPreviewImage = true;
      });
    }
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
                    PreviewImage(_isShowPreviewImage, _image),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        onPressed: () {
                          var _form = _formKey.currentState;
                          if (_form.validate()) {
                            _form.save();
                            Navigator.pop(context, true);
                            saveRecord(1, _amount, _image);
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
            ]));
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
        width: 200,
        height: 200,
        child: Image.network(imgUrl),
      );
    } else {
      content = new Container(height: 0.0, width: 0.0);
    }
    return content;
  }
}

void saveRecord(int status, [double amount = 0.0, String pic]) async {
  var api = new Api();
  var res = await api.saveRecord({
    'status': status,
    'amount': amount,
    'pic': pic,
  });

  Map<String, dynamic> data = res.data;
  if (data['success']) {
    print('save success');
  }
  // Scaffold.of(context).showSnackBar(_saveSuccessSnackBar);
}
