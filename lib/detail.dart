import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatelessWidget {
  final image;
  final amount;
  final status;
  DetailPage(this.image, this.amount, this.status);

  @override
  Widget build(BuildContext context) {
    var imgUrl = (image == null
        ? 'http://p0.meituan.net/scarlett/4613a4d17ef91e5977e73f941276c1d021671.png'
        : image);
    var body = (status != 1 ? empty() : content(imgUrl));
    return Scaffold(
      appBar: AppBar(title: Text('详情')),
      body: body
    );
  }

  Widget empty() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          '我的上帝，没喝奶茶的今天实在是太糟糕了!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      )
    );
  }

  Widget content(String imgUrl) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: imgUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '花了$amount 元买奶茶👍👍👍',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
