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
          SearchPage(
            hideLeft: true,
          ),
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
          _bottomItem('首页',Icons.home,0),
          // 搜索按钮
          _bottomItem('搜索',Icons.search,1),
          // travel按钮
          _bottomItem('Travel',Icons.camera_alt,2),
          // 我的按钮
          _bottomItem('我的',Icons.account_circle,3),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: _currentIndex != index ? _defaultColor : _activeColor),
        ));
  }
}
