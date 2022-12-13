# flutter_ijk_barrage 视频弹幕

### 基于 fijkplayer 的弹幕 可以实时发送弹幕，也可通过 socket 接收显示弹幕

## Installation 安装
Add flutter_ijk_barrage as a dependency in your pubspec.yaml file.

```
dependencies:
  flutter_ijk_barrage:
    git:
      url: https://github.com/liqingyong/flutter_ijk_barrage.git
```

## [Example 示例](https://github.com/liqingyong/flutter_ijk_barrage/example)

```
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter_ijk_barrage/flutter_ijk_barrage.dart';

class VideoDemo extends StatefulWidget {
  const VideoDemo({Key? key}) : super(key: key);

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  //视频
  final FijkPlayer _fijkPlayer = FijkPlayer();
  //弹幕
  final BarrageWallController _barrageWall = BarrageWallController();
  //初始化时是否显示弹幕
  late bool showBarrage = true;

  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {
        "name": "线路资源一",
        "list": [
          {
            "url": "https://media.w3.org/2010/05/sintel/trailer.mp4",
            "name": "视频名称"
          },
          {
            "url": "https://v10.dious.cc/20211009/nONG14sk/index.m3u8",
            "name": "视频名称"
          },
        ]
      }
    ]};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoPlayer(
        player: _fijkPlayer,
        videoList: videoList,//视频
        barrage: _barrageWall,
        showBarrage: showBarrage,//初始化时是否显示弹幕
        onSubmitText: (val) {//弹幕输入框提交的文本
          //发送弹幕到视频显示
          _barrageWall.send([Bullet(child: Text(val.trim(),style:const TextStyle(color: Colors.white,fontSize: 18)),showTime: 3000)]);
        },
        barrageBtnChange: (enable) {
          //开启或关闭弹幕按钮
          setState(() {
            showBarrage = enable;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoDemo oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}

```
## 参考 

- [fijkplayer](https://github.com/befovy/fijkplayer)
- [flutter_barrage](https://github.com/danielwii/flutter_barrage)
- [quiver](https://github.com/google/quiver-dart)

