import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// 地址白名单
const CATCH_URLS = ['m.ctrip.com','m.ctrip.com/html5/','m.ctrip.com/html5'];
/*
    1. webView_plugin 监听Url变化的事件 WebViewReference.onUrlChanged.listen
*/

class WebView extends StatefulWidget {
  // 变量
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  const WebView(
      {this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  // 创建web_view_plugin实例
  final webViewReference = FlutterWebviewPlugin();

  // 保存变量
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  @override
  void initState() {
    //    调用super里的init
    super.initState();
    //    防止页面重新打开
    webViewReference.close();
    //    监听网页变化  通过需要的事件来查看源码需要返回的是什么数据,再做接收
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if(_isToMain(state.url) && !exiting){
            if(widget.backForbid){
              webViewReference.launch(widget.url);
            }else{
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  // 判断跳转首页需要的方法
  _isToMain(String url){
    bool contain = false;
    for(final value in CATCH_URLS){
      /*
      dart 语法糖 ?.
      它的意思是左边如果为空返回 null，否则返回右边的值。
        ```
        A?.B
        如果 A 等于 null，那么 A?.B 为 null
        如果 A 不等于 null，那么 A?.B 等价于 A.B
        ```
       */
      if(url?.endsWith(value)??false){
        contain = true;
        break;
      }
    }
    return contain;
  }

  // 关闭webView的时候一定要及时取消监听
  @override
  void dispose() {
    _onHttpError.cancel();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    webViewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 初始状态bar的颜色
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text('Waiting...'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      // FractionallySizedBox 这个组件是为了撑满整个屏幕的宽度
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
