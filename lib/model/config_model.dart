//class ConfigModel {
//  final String searchUrl;
//
//  ConfigModel({this.searchUrl});
//
//  factory ConfigModel.fromJson(Map<String, dynamic> json) {
//    return ConfigModel(searchUrl: json['searchUrl']);
//  }
//
//  Map<String, dynamic> toJson() {
//    return {
//      searchUrl: searchUrl
//    };
//  }
//}

class ConfigModel {
  String searchUrl;

  ConfigModel({this.searchUrl});

//  ConfigModel.fromJson(Map<String, dynamic> json) {
//    searchUrl = json['searchUrl'];
//  }

  factory ConfigModel.fromJson(Map<String, dynamic> json){
    return ConfigModel(
        searchUrl : json['searchUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchUrl'] = this.searchUrl;
    return data;
  }
}