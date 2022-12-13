


part of flutter_ijk_barrage;


class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool drawerBtn = true;
  @override
  bool nextBtn = true;
  @override
  bool speedBtn = true;
  @override
  bool topBar = true;
  @override
  bool lockBtn = true;
  @override
  bool autoNext = true;
  @override
  bool bottomPro = true;
  @override
  bool stateAuto = true;
  @override
  bool isAutoPlay = true;
}

class VideoPlayer extends StatefulWidget {
  final int curActiveIdx;
  final bool showBarrage;
  final FijkPlayer? player;
  final BarrageWallController barrage;
  final ValueChanged<String>? onSubmitText;//文本提交
  final ValueChanged<bool>? barrageBtnChange;//弹幕按钮点击事件
  final Map<String, List<Map<String, dynamic>>> videoList; //视频

  const VideoPlayer(
      {super.key,this.player, required this.videoList, this.curActiveIdx = 0, required this.barrage,this.showBarrage = true, this.onSubmitText, this.barrageBtnChange});


  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  // FijkPlayer实例
  FijkPlayer get player => widget.player??FijkPlayer();
  BarrageWallController get _barrageWallController  => widget.barrage;

  // 当前tab的index，默认0
  int _curTabIdx = 0;

  // 当前选中的tablist index，默认0
  int _curActiveIdx = 0;

  ShowConfigAbs vCfg = PlayerShowConfig();


  VideoSourceFormat? _videoSourceTabs;

  @override
  void initState() {
    _curActiveIdx = widget.curActiveIdx;
    super.initState();
    // 格式化json转对象
    _videoSourceTabs = VideoSourceFormat.fromJson(widget.videoList);
    // 这句不能省，必须有
    speed = 1.0;
  }

  @override
  void dispose() {
    player.dispose();
    _barrageWallController.dispose();
    super.dispose();
  }

  // 播放器内部切换视频钩子，回调，tabIdx 和 activeIdx
  void onChangeVideo(int curTabIdx, int curActiveIdx) {
    setState(() {
      _curTabIdx = curTabIdx;
      _curActiveIdx = curActiveIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FijkView widgetSc = FijkView(
      width: size.width,
      height: size.height<500?500:size.height,
      color: Colors.black,
      fit: FijkFit.fill,
      player: player,
      panelBuilder: (FijkPlayer player,
          FijkData data,
          BuildContext context,
          Size viewSize,
          Rect texturePos,) {
        /// 使用自定义的布局
        return CustomFijkPanel(
          player: player,
          barrageWall: _barrageWallController,
          // 传递 context 用于左上角返回箭头关闭当前页面，不要传递错误 context，
          // 如果要点击箭头关闭当前的页面，那必须传递当前组件的根 context
          pageContent: context,
          viewSize: viewSize,
          showBarrage: widget.showBarrage,
          texturePos: texturePos,
          // 标题 当前页面顶部的标题部分，可以不传，默认空字符串
          onChangeVideo: onChangeVideo,
          // 当前视频改变钩子，简单模式，单个视频播放，可以不传
          playerTitle: _videoSourceTabs?.video![_curTabIdx]
              ?.list![_curActiveIdx]?.name ?? "",
          // 当前视频源tabIndex
          curTabIdx: _curTabIdx,
          // 当前视频源activeIndex
          curActiveIdx: _curActiveIdx,
          // 显示的配置
          showConfig: vCfg,
          // json格式化后的视频数据
          videoFormat: _videoSourceTabs,
          onSubmitText: widget.onSubmitText,
          barrageBtnChange: widget.barrageBtnChange,
        );
      },
    );
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            // 这里 FijkView 开始为自定义 UI 部分
            child: AspectRatio(aspectRatio: 16/9,child: widgetSc),));
  }

  // 切换播放源
  Future<void> changeCurPlayVideo(int tabIdx, int activeIdx) async {
    await player.reset().then((_) {
      String curTabActiveUrl =
      _videoSourceTabs!.video![tabIdx]!.list![activeIdx]!.url!;
      player.setDataSource(
        curTabActiveUrl,
        autoPlay: true,
      );
      // 回调
      onChangeVideo(tabIdx, activeIdx);
    });
  }

}