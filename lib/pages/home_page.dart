import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ctrip/dao/home_dao.dart';
import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/grid_nav_model.dart';
import 'package:flutter_ctrip/model/home_model.dart';
import 'package:flutter_ctrip/model/sales_box_model.dart';
import 'package:flutter_ctrip/pages/search_page.dart';
import 'package:flutter_ctrip/pages/speak_page.dart';
import 'package:flutter_ctrip/util/navigator_util.dart';
import 'package:flutter_ctrip/widget/grid_nav.dart';
import 'package:flutter_ctrip/widget/loading_container.dart';
import 'package:flutter_ctrip/widget/local_nav.dart';
import 'package:flutter_ctrip/widget/sales_box.dart';
import 'package:flutter_ctrip/widget/search_bar.dart';
import 'package:flutter_ctrip/widget/sub_nav.dart';
import 'package:flutter_ctrip/widget/webview.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

// APPBAR_SCROLL_OFFSET 滚动最大距离
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// _开头表示内部类
class _HomePageState extends State<HomePage> {
  // 定义一个数组, 来存放图片地址
  List _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];

  // 定义 appBarAlpha
  double appBarAlpha = 0;

  // 定义 接收网络请求回来的信息
  String resultString = "";

  // 接受请求道的navBar
  List<CommonModel> localNavList = [];
  List<CommonModel> subList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
    // 关闭启动屏
    Future.delayed(Duration(milliseconds: 3000), () {
      FlutterSplashScreen.hide();
    });
  }

  _onScroll(offset) {
    // 修改appBarAlpha
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  //  // es6 的标准
  //  loadData(){
  //    HomeDao.fetch().then((result){
  //      setState(() {
  //        resultString = json.encode(result);
  //      });
  //    }).catchError((e){
  //      resultString = e.toString();
  //    });
  //  }
  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        // resultString = json.encode(model.bannerList);
        localNavList = model.localNavList;
        subList = model.subNavList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        //        resultString = e.toString();
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      // Stack代码中前面的元素会被叠在后面的元素下面
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            // 移除padding  MediaQuery.removePadding
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              // RefreshIndicator 下拉刷新组件
              child: RefreshIndicator(
                // 下拉刷新属性
                onRefresh: _handleRefresh,
                // 监听列表滚动 NotificationListener
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    // scrollNotification 要传入的参数
                    // scrollNotification.depth == 0 表示监听到这一整个ListView
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      // 滚动且是列表滚动的时候
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                    return false;
                  },
                  child: _listView,
                ),
              ),
            ),
            // 改变透明度
            _appBar,
          ],
        ),
      ),
    );
  }

  // _listView
  Widget get _listView {
    return ListView(
      children: <Widget>[
        // banner轮播图
        Container(
          height: 160,
          child: Swiper(
            // count取数组长度
            itemCount: bannerList.length,
            // 是否自动播放
            autoplay: true,
            // itemBuilder(BuildContext context, int index)
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  CommonModel model = bannerList[index];
                  NavigatorUtil.push(
                      context,
                      WebView(
                        url: model.url,
                        title: model.title,
                        hideAppBar: model.hideAppBar,
                      ));
                },
                child: Image.network(
                  bannerList[index].icon,
                  fit: BoxFit.fill,
                ),
              );
            },
            // pagination 指示器, banner图下的小点
            pagination: SwiperPagination(),
          ),
        ),
        // 导航图标
        //                    GridNav(gridNavModel: null),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        // GridNav 图形模块导航
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: GridNav(
            gridNavModel: gridNavModel,
          ),
        ),
        // subNav 活动入口按钮
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(subNavList: subList),
        ),
        // salesBox 更多活动促销
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(salesBox: salesBoxModel),
        ),
        Container(
          height: 800,
          child: ListTile(
            title: Text(resultString),
          ),
        ),
      ],
    );
  }

  //  // 原来_arrBar
  //  Widget get _appBar{
  //    return Opacity(
  //      opacity: appBarAlpha,
  //      child: Container(
  //        height: 80,
  //        decoration: BoxDecoration(color: Colors.white),
  //        child: Center(
  //          child: Padding(
  //            padding: EdgeInsets.only(top: 20),
  //            child: Text("首页"),
  //          ),
  //        ),
  //      ),
  //    );
  //  }

  // 加入searchBar
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // AppBar 渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        ),
      ],
    );
  }

  _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}
