import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import 'video_widget.dart';

class VideoList extends StatefulWidget {
  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  var loading=true;
  var dataFinal;

  @override
  void initState() {
    // TODO: implement initState
    loaddata();
    super.initState();
  }
  loaddata()async{
    String data = await DefaultAssetBundle.of(context).loadString("asset/data.json");
    final jsonResult = jsonDecode(data); //latest Dart
    dataFinal=jsonResult;
    setState(() {
      loading=false;
    });
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YT Auto player"),
      ),
        body:
        loading?Container(
          color:Colors.white ,
          child: Center(
              child:CircularProgressIndicator()
          ),
        ): Stack(
          fit: StackFit.expand,
          children: <Widget>[
            InViewNotifierList(
              scrollDirection: Axis.vertical,
              initialInViewIds: ['0'],
              isInViewPortCondition:
                  (double deltaTop, double deltaBottom, double viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              },
              itemCount: 10,
              builder: (BuildContext context, int index) {
                return Container(
                  width: double.infinity,
                  height: 400.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return InViewNotifierWidget(
                        id: '$index',
                        builder:
                            (BuildContext context, bool isInView, Widget? child) {
                          return VideoWidget(
                              play: isInView,
                              cover: dataFinal[index]['coverPicture'],
                              title: dataFinal[index]['title'],
                              url: dataFinal[index]['videoUrl']);
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 1.0,
                color: Colors.redAccent,
              ),
            )
          ],
        ));
  }
}