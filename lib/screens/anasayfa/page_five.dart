import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';
import 'package:provider/provider.dart';

class PageFive extends StatefulWidget {
  @override
  _PageFiveState createState() => _PageFiveState();
}

class _PageFiveState extends State<PageFive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesabım"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _cikisYap();
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: 200,
            color: Colors.red,
          )
        ],
      ),
    );
  }

  void _cikisYap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}
