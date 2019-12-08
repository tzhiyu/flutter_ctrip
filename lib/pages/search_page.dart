import 'package:flutter/material.dart';
import 'package:flutter_ctrip/dao/search_dao.dart';
import 'package:flutter_ctrip/model/search_model.dart';
import 'package:flutter_ctrip/pages/speak_page.dart';
import 'package:flutter_ctrip/widget/search_bar.dart';
import 'package:flutter_ctrip/widget/webview.dart';

/// 搜索URL
const URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  /// 定义入参
  final bool hideLeft;
  final String searchUrl;
  final String keyword;

  /// 提示文案
  final String hint;

  const SearchPage(
      {this.hideLeft, this.searchUrl = URL, this.keyword, this.hint});

  @override
  _SearchPageState createState() => _SearchPageState();
}

/// _开头表示内部类
class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  void initState() {
    if(widget.keyword != null){
      _onTextChange(widget.keyword);
    }
    super.initState();
  } // 接收到keyword之后需要重载页面


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///        appBar: AppBar(),
      body: Column(
        children: <Widget>[
          /// appBar
          _appBar(),

          /// 展示传回来的信息
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: searchModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int position) {
                      return _item(position);
                    }),
              ))
        ],
      ),
    );
  }

  // 发起搜索
  _onTextChange(String text) {
    keyword = text;
    String url = widget.searchUrl + text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    SearchDao.fetch(url, text).then((SearchModel model) {
      // 只有当当前输入的内容和服务端返回的内容一致时才渲染
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _appBar() {
    return Column(
      children: <Widget>[
        /// 阴影遮罩
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              /// AppBar 渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              speakClick: _jumpToSpeak,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _jumpToSpeak (){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeakPage(),
        ));
  }
  //// item
  _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: item.url,
                      title: '详情',
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              height: 26,
              width: 26,
              child: Image(image: AssetImage(_typeImage(item.type))),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _typeImage(String type) {
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }

    // TextSpan就是在Text中显示富文本的一个辅助类
    List<TextSpan> spans = [];
    // 左边的text
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    // 右边的text
    spans.add(TextSpan(
        text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans));
  }

  _subTitle(SearchItem item) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        _isTimePrice(item.price),
        TextSpan(
          text: ' ' + (item.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        )
      ]),
    );
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    // 拆分传入的word
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: keyword, style: normalStyle));
      }
    }
    return spans;
  }

  _isTimePrice(String price){
    if (price != null){
      return TextSpan(
        text: '实时计价: '+ price,
        style: TextStyle(fontSize: 16, color: Colors.orange),
      );
    }

    return TextSpan(
      text: '',
    );
  }
}
