import 'package:flutter/material.dart';

// 枚举  不同情况下的searchBar
enum SearchBarType { home, normal, homeLight }

// SearchBar
class SearchBar extends StatefulWidget {
  // 参数
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 根据searchBarType的枚举类型, 判断不同的searchBar的样式
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  // 普通搜索页的搜索框
  _genNormalSearch() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          // 显示是否有返回按钮
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 2, 10, 5),
                child: widget?.hideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                        size: 26,
                      ),
              ),
              widget.leftButtonClick),
          // 显示中间的文本输入框
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          // 显示搜索按钮
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          // 显示是否有返回按钮
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '上海',
                        style: TextStyle(color: _homeFontColor(), fontSize: 14),
                      ),
                      Icon(
                        Icons.expand_more,
                        color: _homeFontColor(),
                        size: 22,
                      ),
                    ],
                  )),
              widget.leftButtonClick),
          // 显示中间的文本输入框
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          // 显示搜索按钮
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      // 给input框设置样式的装饰器
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffA9A9A9)
                : Colors.blue,
          ),
          // 宽度自适应Expanded
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    // 输入文本框的样式
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      border: InputBorder.none,
                      hintText: widget.hint ?? '',
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defaultText,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    widget.inputBoxClick),
          ),
          // 添加右边语音按钮
          !showClear
              ? _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
              : _wrapTap(
                  Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.grey,
                  ), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                })
        ],
      ),
    );
  }

  // 包裹child来实现回调
  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  // 监听TextField
  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  // 首页前景色
  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
/*
1. 根据需求 有2种类型
2. 清除的按钮
3. 发送和回调的显示
4. 是否隐藏左边的icon
 */
