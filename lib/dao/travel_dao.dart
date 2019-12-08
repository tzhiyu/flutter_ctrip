import 'dart:convert';

import 'package:flutter_ctrip/model/travel_model.dart';
import 'package:http/http.dart' as http;


// 必须要的参数
var Params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};

/// 旅拍类别接口
class TravelDao {
  static Future<TravelItemModel> fetch(String url,String groupChannelCode,int pageIndex, int pageSize) async {
    // 修改固定入参中动态修改的参数部分
    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;
    
    final response = await http.post(url,body: jsonEncode(Params));
    if (response.statusCode == 200) {
      // fix中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelItemModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel');
    }
  }
}
