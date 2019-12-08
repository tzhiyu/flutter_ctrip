import 'package:flutter/material.dart';
import 'package:flutter_ctrip/pages/home_page.dart';
import 'package:flutter_ctrip/pages/my_page.dart';
import 'package:flutter_ctrip/pages/search_page.dart';
import 'package:flutter_ctrip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

// _开头表示内部类
class _TabNavigatorState extends State<TabNavigator> {
  // 定义按钮的颜色
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;

  // 定义页面的根节点
  final PageController _controller = PageController(
    initialPage: 0, // 初始位置
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true,),
          TravelPage(),
          MyPage(),
        ],
        // 禁止PageView左右滑动
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          // 主页按钮
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.home,
                color: _activeColor,
              ),
              title: Text(
                '首页',
                style: TextStyle(
                    color: _currentIndex != 0 ? _defaultColor : _activeColor),
              )),
          // 搜索按钮
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.search,
                color: _activeColor,
              ),
              title: Text(
                '搜索',
                style: TextStyle(
                    color: _currentIndex != 1 ? _defaultColor : _activeColor),
              )),
          // travel按钮
          BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.camera_alt,
                color: _activeColor,
              ),
              title: Text(
                'Travel',
                style: TextStyle(
                    color: _currentIndex != 2 ? _defaultColor : _activeColor),
              )),
          // 我的按钮
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: _activeColor,
              ),
              title: Text(
                '我的',
                style: TextStyle(
                    color: _currentIndex != 3 ? _defaultColor : _activeColor),
              )),
        ],
      ),
    );
  }
}
