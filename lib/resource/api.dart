import 'dart:io';
import 'package:dio/dio.dart';

class Api {
  Dio dio;
  String _userId = '5d4996ef7018fabeba9c1182';

  Api() {
    dio = new Dio();
    dio.options.baseUrl = 'http://127.0.0.1:3000/api';
    dio.options.connectTimeout = 5000;
  }

  Future getRecordList() async {
    return await dio.get('/record/list?userId=$_userId');
  }

  Future saveRecord(Map<String, dynamic> params) async {
    params['userId'] = _userId;
    return await dio.post('/record', data: params);
  }

  Future getTodayRecord() async {
    var res = await dio.get('/record/today?userId=$_userId');
    return res.data;
  }

  Future uploadImage(File image) async {
    FormData form = new FormData.from({
      "photo": new UploadFileInfo(image, image.uri.toFilePath()),
    });
    var res = await dio.post('/image/upload', data: form);
    return res.data;
  }
}
