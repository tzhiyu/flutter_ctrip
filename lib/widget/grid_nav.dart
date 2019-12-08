import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ctrip/model/common_model.dart';
import 'package:flutter_ctrip/model/grid_nav_model.dart';
import 'package:flutter_ctrip/util/navigator_util.dart';
import 'package:flutter_ctrip/widget/webview.dart';

// 网格卡片
class GridNav extends StatelessWidget {
  // 接受传入的参数
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel})
      : super(key: key); // @required 加上就是必填
  @override
  Widget build(BuildContext context) {
    // flutter自带一个PhysicalModel的Widget来实现整个组件的圆角
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      // 裁切
      clipBehavior: Clip.antiAlias,
      child: Column(
        // 在children中返回一个数组
        children: _gridNavItems(context),
      ),
    );
  }

  // _gridNavItems方法构造从主页中拿回来的参数 这个方法需要接收上下文,所以传入一个BuildContext 类型的context
  // 构造板块纵向的三大快布局
  _gridNavItems(BuildContext context) {
    // 在children中需要的是一个Widget类型的List, 于是声明一个空数组来接受这个构造完成的数据
    List<Widget> items = [];
    // 异常逻辑判断
    if (gridNavModel == null) return items;
    // 正式开始构建组件
    // 1.  hotel模块
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    // 2.  flight模块
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    // 3.  travel模块
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  // 构造板块横向的布局,  被纵向板块包含的 本模块包含左中右部分
  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    // 让上述3个item并列排列
    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(Expanded(
        child: item,
        flex: 1,
      ));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      // 装饰器
      decoration: BoxDecoration(
          // 线性渐变
          gradient: LinearGradient(colors: [startColor, endColor])),
      child: Row(children: expandItems),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            // 设置一个顶部边距
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                model.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        model);
  }

  _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, bottomItem, false),
        ),
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      // 盛满父布局的宽度
      widthFactor: 1,
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: borderSide,
              bottom: first ? borderSide : BorderSide.none,
            ),
          ),
          child: _wrapGesture(
              context,
              Center(
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              item)),
    );
  }

  // 让item被点击的时候跳到详情页
  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
            ));
      },
      child: widget,
    );
  }
}
