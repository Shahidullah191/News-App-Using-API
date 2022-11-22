import 'dart:convert';

import 'package:news_app_day_37/custom/const.dart';
import 'package:news_app_day_37/model/news_model.dart';
import 'package:http/http.dart' as http;


class CustomHttp{
  Future<List<Articles>> fetchAllNewsData({required String pageNo, required String sortBy}) async {
    List<Articles> allNewsData = [];
    Articles articles;

    var response = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=tesla&page=$pageNo&pageSize=10&sortBy=$sortBy&apiKey=d4f25ffd61c54b98ba1b2420cf4e5065"));
    print("response is ${response.body}");

    var data = jsonDecode(response.body);

    for(var i in data["articles"]){
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }
    return allNewsData;
  }


  Future<List<Articles>> fetchSearchNewsData({required String pageNo, required String query}) async {
    List<Articles> allNewsData = [];
    Articles articles;

    var response = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=$query&page=$pageNo&pageSize=10&apiKey=d4f25ffd61c54b98ba1b2420cf4e5065"));
    print("response is ${response.body}");

    var data = jsonDecode(response.body);

    for(var i in data["articles"]){
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }
    return allNewsData;
  }
}